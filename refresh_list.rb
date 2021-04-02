require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'open-uri'
require 'yaml'
require 'csv'

module RefreshList
  SOURCE_URI = 'https://www.currency-iso.org/dam/downloads/lists/list_one.xml'.freeze
  RESULT_FILE_PATH = 'currencies.csv'.freeze
  SYMBOLS = YAML.load_file('currency_symbols.yml').freeze
  HEADER = ['ENTITY', 'Currency', 'Alphabetic Code', 'Numeric Code', 'Minor unit', 'Symbol'].freeze

  extend self

  def perform
    CSV.open(RESULT_FILE_PATH, 'w') { |c| c << HEADER }

    xml_data = read_source
    result_data = build_result_data xml_data: xml_data
    result_data.each { |data| CSV.open(RESULT_FILE_PATH, 'a') { |c| c << data } }
  end

  def read_source
    URI.open(SOURCE_URI).read
  end

  def build_result_data(xml_data:)
    result = []

    xml_document = Nokogiri::XML(xml_data)
    xml_document.xpath('//CcyNtry').each do |xml_node|
      data = [
        xml_node.at_xpath('CtryNm')&.content,
        xml_node.at_xpath('CcyNm')&.content,
        xml_node.at_xpath('Ccy')&.content,
        xml_node.at_xpath('CcyNbr')&.content,
        xml_node.at_xpath('CcyMnrUnts')&.content,
        SYMBOLS[xml_node.at_xpath('Ccy')&.content]
      ]
      result << data
    end

    result
  end
end

RefreshList.perform
