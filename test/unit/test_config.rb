# coding: utf-8

require 'test_helper'

class ThinReports::TestConfig < Minitest::Test
  include ThinReports::TestHelper

  def test_generator_of_Configuration_should_return_configuration_of_generator
    config = ThinReports::Configuration.new
    assert_instance_of ThinReports::Generator::Configuration, config.generator
  end

  def test_config_should_return_configuration_of_thinreports
    assert_instance_of ThinReports::Configuration, ThinReports.config
  end

  def test_configure_should_exec_an_given_block_with_config_which_instance_of_Configuration
    ThinReports.configure do |config|
      assert_instance_of ThinReports::Configuration, config
    end
  end

  def test_fallback_fonts
    config = ThinReports::Configuration.new

    # should be empty by default
    assert_empty config.fallback_fonts

    config.fallback_fonts = 'Helvetica'
    assert_equal config.fallback_fonts, ['Helvetica']

    config.fallback_fonts = ['/path/to/font.ttf', 'Courier New']
    assert_equal config.fallback_fonts, ['/path/to/font.ttf', 'Courier New']

    config.fallback_fonts = []
    config.fallback_fonts << 'Helvetica'
    config.fallback_fonts << 'IPAMincho'
    config.fallback_fonts.unshift 'Times New Roman'
    assert_equal config.fallback_fonts, ['Times New Roman', 'Helvetica', 'IPAMincho']
  end
end
