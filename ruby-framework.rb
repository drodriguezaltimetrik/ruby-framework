require 'rubygems'
require 'json'
require 'watir-webdriver'
steps_1 = JSON.parse File.read('steps_1.json')


@browser = Watir::Browser.new :firefox
