#!/usr/bin/env ruby

require "json"
require "nokogiri"
require "logger"


basedir = "#{File.dirname(__FILE__)}/.."

logger = Logger.new(STDOUT)

items = []

@doc = Nokogiri::XML(File.open("#{File.dirname(__FILE__)}/catalogo.tei.xml"))

@doc.xpath("//xmlns:list[@type='catalog']/xmlns:item").each { |item|
  id = item.xpath('@xml:id').to_s
  n = item.xpath('@n').to_s
  dcl = item.xpath('@corresp').to_s.split(' ')

  items.append({"id": id, "n": n, "dcl": dcl})
}

# items.to_json
File.write("#{basedir}/tmp/catalogo_items.json", JSON.dump(items))
