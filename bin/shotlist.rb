require 'marc'
require 'csv'

TRUNCATE_STRINGS_TO=250

HERE = File.dirname(File.expand_path(__FILE__))
MARC_FILE = "#{HERE}/../cicognara.mrx.xml"
CSV_FILE = "#{HERE}/../cicognara_shotlist.csv"

def cico_number?(f_024)
  f_024.indicator1 == '7' && f_024['2'] == 'cico'
end

def dcl_number?(f_024)
  f_024.indicator1 == '7' && f_024['2'] == 'dclib'
end

def get_catalogo_numbers(record)
  fields = record.fields('024').select{ |f| cico_number?(f) }.map{ |f| f['a'] }
  if fields.length == 0
    raise "#{Record} #{record['001'].value} has no catalogo numbers"
  else
    fields
  end
end

def get_dcl_number(record)
  fields = record.fields('024').select{ |f| dcl_number?(f) }.map{ |f| f['a'] }
  if fields.length != 1
    raise "#{Record} #{record['001'].value} has #{fields.length} dclib numbers"
  else
    fields.first[5..7]
  end
end

def truncate(s)
  unless s.nil?
    s = "#{s[0..TRUNCATE_STRINGS_TO]} [...]" if s.length >= TRUNCATE_STRINGS_TO
    s.force_encoding(Encoding::UTF_8)
  end
  s
end

def process_record(record, csv_writer)
  bib_id = record['001'].value
  title = truncate(record['245']['a'])
  creator = truncate(record['245']['c'])
  catalogo_numbers = get_catalogo_numbers(record).join(', ')
  dcl_number = get_dcl_number(record)
  csv_writer << [title, creator, bib_id, catalogo_numbers, dcl_number]
end

reader = MARC::XMLReader.new(MARC_FILE)

CSV.open(CSV_FILE, 'w', col_sep: "\t") do |csv_writer|
  csv_writer << ['Title', 'Creator', 'Princeton Bib', 'Catalogo Number(s)', 'DCL Number']
  reader.each do |record|
    process_record(record, csv_writer)
  end
end
