require 'rubygems'
require 'json'
require 'watir-webdriver'

class ExpectationNotMet < StandardError; end

def parse_element(data)
  case data[:event].downcase
    when 'go to'
      @browser.goto data[:url]
    when 'type'
      page_object = @page_object[data[:page_object]][0]
      @browser.element(:css => page_object[data[:element]]).send_keys data[:value]
    when 'click'
      page_object = @page_object[data[:page_object]][0]
      @browser.element(:css => page_object[data[:element]]).click
  end
end

def expect_parse(data)
  page_object = @page_object[data[:page_object]][0]
  case data[:attribute].downcase
    when 'existence'
      result = @browser.element(:css => page_object[data[:element]]).exist?
      raise ExpectationNotMet, "expected #{data[:expected]} got #{result}" unless result == data[:expected]
    when 'visibility'
      result = @browser.element(:css => page_object[data[:element]]).visible?
      raise ExpectationNotMet, "expected #{data[:expected]} got #{result}" unless result == data[:expected]
  end
end

begin
  @steps = JSON.parse File.read('steps_2.json')
  @page_object = JSON.parse File.read('page_object.json')

  @browser = Watir::Browser.new @steps['environment'][0]['browser'].downcase.to_sym


  @steps['steps'].each do |step|
    parse_element :event => step['event'], :element => step['element'], :value => step['element'], :page_object => step['page_object'], :url => step['url']
  end

  @steps['expected_results'].each do |expectations|
    expect_parse :element => expectations['element'], :attribute => expectations['attribute'], :action => expectations['action'],
                 :expectations => expectations['equals'], :page_object => expectations['page_object'], :expected => expectations['expected']
  end

ensure
  @browser.close
end

'aaa'