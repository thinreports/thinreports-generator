# coding: utf-8

require 'test/unit/helper'

class ThinReports::TestConfig < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def test_generator_of_Configuration_should_return_configuration_of_generator
    @config = ThinReports::Configuration.new
    assert_instance_of ThinReports::Generator::Configuration, @config.generator
  end
  
  def test_config_should_return_configuration_of_thinreports
    assert_instance_of ThinReports::Configuration, ThinReports.config
  end
  
  def test_configure
    ThinReports.configure do |config|
      assert_instance_of ThinReports::Configuration, config
    end
  end
end