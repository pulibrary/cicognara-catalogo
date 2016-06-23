require 'marc'
require 'csv'

TRUNCATE_STRINGS_TO=250
HERE = File.dirname(File.expand_path(__FILE__))
MARC_FILE = "#{HERE}/../cicognara.mrx.xml"
CSV_FILE = "#{HERE}/../cicognara_shotlist.csv"

class Row
  def initialize(marc_record)
    @record = marc_record
    @all_catalogo_numbers = all_catalogo_numbers
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
    ['Title', 'Creator', 'PUL Bib', 'Cico Nr(s)', 'Addl Cico Nr(s)', 'DCL Nr']
  end

  def to_a
    [title, creator, id, catalogo_number, addl_catalogo_numbers, dcl_number]
  end

  def catalogo_number
    @all_catalogo_numbers.first
  end

  def addl_catalogo_numbers
    @all_catalogo_numbers.drop(1).join(', ')
  end

  def dcl_number
    fields = @record.fields('024').select { |f|
      self.class.dcl_number?(f)
    }.map{ |f| f['a'] }
    if fields.length != 1
      raise "#{Record} #{@record['001'].value} has #{fields.length} dclib numbers"
    else
      fields.first[5..7] # strips 'cico:'
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
  def all_catalogo_numbers
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
