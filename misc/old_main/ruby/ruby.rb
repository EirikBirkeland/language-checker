require 'rubygems'
require 'nokogiri'
require 'colorize'
doc = Nokogiri::XML(File.open("combined.xlf"))
#puts @doc.xpath("//trans-unit//source")
#puts @doc.css("trans-unit source")

transunit = "xliff/file/body/trans-unit"

source = Array.new
target = Array.new

doc.xpath("#{transunit}").each do |node|
  
  id = node['id']
  translate = node['translate']
  source = node.xpath("./source").text
  target = node.xpath("./target").text

end

simple = "tests/simple.txt"
lines = IO.readlines(simple)
lines.each do |line|
  test = line.split("\t")
  source.each do |test|
     puts test
end
end
