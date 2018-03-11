# frozen_string_literal: true

require 'test_helper'

class Thinreports::TestConfig < Minitest::Test
  include Thinreports::TestHelper

  def test_config_should_return_configuration_of_thinreports
    assert_instance_of Thinreports::Configuration, Thinreports.config
  end

  def test_configure_should_exec_an_given_block_with_config_which_instance_of_Configuration
    Thinreports.configure do |config|
      assert_instance_of Thinreports::Configuration, config
    end
  end

  def test_fallback_fonts
    config = Thinreports::Configuration.new

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

  def test_register_font
    config = Thinreports::Configuration.new

    assert_equal({}, config.fonts)

    config.register_font('Foo',
      normal: 'foo.ttf',
      bold: 'foo_bold.ttf',
      italic: 'foo_italic.ttf',
      bold_italic: 'foo_bold_italic.ttf'
    )
    assert_equal({
      normal: 'foo.ttf',
      bold: 'foo_bold.ttf',
      italic: 'foo_italic.ttf',
      bold_italic: 'foo_bold_italic.ttf'
    }, config.fonts['Foo'])

    config.register_font('Bar', normal: 'bar.ttf')
    assert_equal({
      normal: 'bar.ttf',
      bold: 'bar.ttf',
      italic: 'bar.ttf',
      bold_italic: 'bar.ttf'
    }, config.fonts['Bar'])

    assert_equal({
      'Foo' => {
        normal: 'foo.ttf',
        bold: 'foo_bold.ttf',
        italic: 'foo_italic.ttf',
        bold_italic: 'foo_bold_italic.ttf'
      },
      'Bar' => {
        normal: 'bar.ttf',
        bold: 'bar.ttf',
        italic: 'bar.ttf',
        bold_italic: 'bar.ttf'
      }
    }, config.fonts)
  end
end
