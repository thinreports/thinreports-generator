# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::TestConfiguration < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def setup
    @config = ThinReports::Generator::Configuration.new
  end
  
  def test_pdf_should_return_configuration_of_pdf
    assert_instance_of ThinReports::Generator::PDF::Configuration, @config.pdf
  end
  
  def test_default_should_return_pdf_by_default
    assert_equal @config.default, :pdf
  end
  
  def test_default_should_raise_when_value_is_unknown_generator_type
    assert_raises ThinReports::Errors::UnknownGeneratorType do
      @config.default = :unknown
    end
  end
end