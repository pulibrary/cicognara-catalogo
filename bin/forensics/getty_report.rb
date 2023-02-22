#!/usr/bin/env ruby

require "fileutils"
require "json"
require "set"
require "csv"
require "logger"

basedir = "#{File.dirname(__FILE__)}/.."

logger = Logger.new(STDOUT)

records = []

Dir["#{basedir}/tmp/resources/*.json"].each do |file|
  json = JSON.parse(File.open(file).read)

  cico = json['identifier'].find {|id| id['@type'] == 'cicognaraNumber'}
  dcl = json['identifier'].find {|id| id['@type'] == 'dclNumber'}

  next unless (cico or dcl)

  data = {id: json['@id'], file: File.basename(file), cico: ''}

  if cico
       data[:cico] = cico['value']
  else
      logger.warn("No cico number for #{file}")
  end

  if dcl
       data[:dcl] = dcl['value']
    else
      logger.warn("No dcl number for #{file}")
      data[:dcl] = ''
  end

  data[:virtual_collection] = nil
    if json["isPartOf"]
    virtual_collection = json["isPartOf"].find { |x|
      x['@type'] == 'virtualCollection'
    }
    if virtual_collection
      data[:virtual_collection] = virtual_collection['label']
    else
      logger.warn("not part of a virtual collection: #{file}")
    end
    else
      logger.warn("not part of anything: #{file}")
  end

  data[:manifest] = nil

  if json['hasFormat']
    manifest = json['hasFormat'].find { |x| x['@type'] == "iiif"}
    data[:manifest] = manifest['value']
  end

  records.append(data)
end

CSV.open("#{basedir}/tmp/getty_report.csv", "wb") do |csv|
  csv << ["id", "filename", "cico", "dcl", "virtual_collection", "manifest"]
  records.each do |data|
    csv << [data[:id],
            data[:file],
            data[:cico],
            data[:dcl],
            data[:virtual_collection],
            data[:manifest]
           ]
  end
end


  File.write("#{basedir}/tmp/getty_report.json", JSON.dump(records))
