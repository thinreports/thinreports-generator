# coding: utf-8

require 'test_helper'

class Thinreports::Layout::TestConfiguration < Minitest::Test
  include Thinreports::TestHelper

  Configuration = Thinreports::Layout::Configuration

  def test_disable_methods
    layout = Thinreports::Layout.new layout_file.path
    configuration = Configuration.new(layout)

    assert_raises NoMethodError do
      @config.values
    end
  end
end
