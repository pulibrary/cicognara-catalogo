#!/usr/bin/env ruby

require "fileutils"
require "json"
require "set"
require "csv"
require "logger"

basedir = "#{File.dirname(__FILE__)}/.."

logger = Logger.new(STDOUT)

getty_records = JSON.parse(File.open("#{basedir}/tmp/getty_report.json").read)
catalogo_items = JSON.parse(File.open("#{basedir}/tmp/catalogo_items.json").read)

results = []

catalogo_items.each { |item|
  cico_num = item['n']

  rec = {}

  rec["cico_num"] = cico_num

  cico_hit = getty_records.find { |record| record["cico"] == cico_num}


  dcl_nums = Array(item['dcl']).map { |i| i.split(':')[1]}
  dcl_hit = getty_records.find { |record| Array(record['dcl']).intersect? dcl_nums }

  if cico_hit
    rec["cico_hit"] = cico_hit["file"]
  else
    puts "No Getty record for Catalog item #{cico_num}" unless rec["cico_hits"]
  end

  if dcl_hit
    rec["dcl_hit"] = dcl_hit["file"]
  else
    puts "No Getty record for dcl nums #{item['dcl']}" unless rec["dcl_hits"]
  end

  results.append(rec)
}

CSV.open("#{basedir}/tmp/missing.csv", "wb") do |csv|
  csv << ["cico_num", "cico_hit", "dcl_hit"]
  results.each do |result|
    csv << [result["cico_num"],
            result["cico_hit"],
            result["dcl_hit"]
           ]
  end
end
