require 'marc'
require 'csv'
require 'nokogiri'

TRUNCATE_STRINGS_TO=250
HERE = File.dirname(File.expand_path(__FILE__))
MARC_FILE = "#{HERE}/../cicognara.mrx.xml"
CSV_FILE = "#{HERE}/../cicognara_shotlist.csv"
TEI_1 = "#{HERE}/../catalogo1.tei.xml"
TEI_2 = "#{HERE}/../catalogo2.tei.xml"
TEI_NS = 'http://www.tei-c.org/ns/1.0'

class CatalogoLookup
  def initialize(teis)
    @teis = teis
  end

  def [](dclib_no)
    @data ||= generate_lookup
    @data[dclib_no]
  end

  def generate_lookup
    data = {}
    @teis.each { |tei_path| data.merge!(lookup_from_tei(tei_path)) }
    data
  end

  def lookup_from_tei(tei_path)
    data = { }
    items_elements_from_tei(tei_path).each do |item|
      catalogo_n = item.attribute('n').value
      item.attribute('corresp').value.split(' ').each do |dclib_n|
        if data.has_key?(catalogo_n)
            data[dclib_n] << catalogo_n
        else
          data[dclib_n] = [catalogo_n]
        end
      end
    end
    data
  end

  def items_elements_from_tei(tei_path)
    doc = Nokogiri::XML(File.open(tei_path))
    doc.xpath('//tei:item[@n and @corresp]', tei: TEI_NS)
  end

end

class Row

  CATALOGO_LOOKUP = CatalogoLookup.new([TEI_1, TEI_2])

  def initialize(marc_record)
    @record = marc_record
    @all_fiche_numbers = all_fiche_numbers
  end

  def self.cico_number?(f_024)
    f_024.indicator1 == '7' && f_024['2'] == 'cico'
  end

  def self.dcl_number?(f_024)
    f_024.indicator1 == '7' && f_024['2'] == 'dclib'
  end

  def self.truncate(s)
    unless s.nil?
      s = "#{s[0..TRUNCATE_STRINGS_TO]} [...]" if s.length >= TRUNCATE_STRINGS_TO
      s.force_encoding(Encoding::UTF_8)
    end
    s
  end


  def self.header
    ['Title', 'Creator', 'PUL Bib', 'Fiche Nr(s)', 'Addl Nr(s)', 'Catalogo Number', 'DCL Nr']
  end

  def to_a
    [title, creator, id, fiche_number, addl_fiche_numbers, catalogo_number, dcl_number]
  end

  def catalogo_number
    # This raises "undefined method `join' for nil:NilClass (NoMethodError)"
    # implying that are dclib numbers in the MARC that aren't in the TEI
    n = "cico:#{dcl_number}"
    begin
      CATALOGO_LOOKUP[n].join(', ')
    rescue NoMethodError
      puts("#{n} is not in the TEI")
    end
  end

  def fiche_number
    @all_fiche_numbers.first
  end

  def addl_fiche_numbers
    @all_fiche_numbers.drop(1).join(', ')
  end

  def dcl_number
    @dcl_number ||= begin
      fields = @record.fields('024').select { |f|
        self.class.dcl_number?(f)
      }.map{ |f| f['a'] }
      if fields.length != 1
        raise "#{Record} #{@record['001'].value} has #{fields.length} dclib numbers"
      else
        fields.first[5..7] # strips 'cico:'
      end
    end
  end

  def id
    @record['001'].value
  end

  def title
    self.class.truncate(@record['245']['a'])
  end

  def creator
    self.class.truncate(@record['245']['c'])
  end

  private
  def all_fiche_numbers
    fields = @record.fields('024').select { |f|
      self.class.cico_number?(f)
    }.map{ |f| f['a'] }
    if fields.length == 0
      raise "#{Record} #{@record['001'].value} has no catalogo numbers"
    else
      fields
    end
  end

end


reader = MARC::XMLReader.new(MARC_FILE)
CSV.open(CSV_FILE, 'w', col_sep: "\t", force_quotes: true) do |csv_writer|
  csv_writer << Row.header
  reader.each do |record|
    csv_writer << Row.new(record).to_a
  end
end
