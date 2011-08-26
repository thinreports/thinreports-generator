# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::TestConfiguration < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def test_pdf_should_return_configuration_of_pdf
    @config = ThinReports::Generator::Configuration.new
    assert_instance_of ThinReports::Generator::Pdf::Configuration, @config.pdf
  end
end