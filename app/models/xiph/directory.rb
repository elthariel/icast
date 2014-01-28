require 'nokogiri'
require 'open-uri'

class Xiph::Directory
  attr_reader :path, :xml

  def initialize(path)
    @path = path
    @xml = Nokogiri::XML(open(path))
  end

  def each
    xml.xpath('//directory/entry').each do |xml_node|
      yield Xiph::Entry.new(xml_node)
    end
  end
end
