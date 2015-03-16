# coding: utf-8

require 'test_helper'

class Thinreports::Layout::TestConfiguration < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Configuration = Thinreports::Layout::Configuration

  def setup
    layout = Thinreports::Layout.new data_file('layout_text1.tlf')
    @config = Configuration.new(layout)
  end

  def test_disable_methods
    assert_raises NoMethodError do
      @config.values
    end
  end
end
