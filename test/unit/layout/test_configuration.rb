# coding: utf-8

require 'test_helper'

class ThinReports::Layout::TestConfiguration < Minitest::Test
  include ThinReports::TestHelper

  # Alias
  Configuration = ThinReports::Layout::Configuration

  def setup
    layout = ThinReports::Layout.new data_file('layout_text1.tlf')
    @config = Configuration.new(layout)
  end

  def test_disable_methods
    assert_raises NoMethodError do
      @config.values
    end
  end
end
