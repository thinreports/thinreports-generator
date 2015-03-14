# coding: utf-8

require 'test_helper'

class Thinreports::TestLayout < Minitest::Test
  include Thinreports::TestHelper

  def test_new
    assert_instance_of Thinreports::Layout::Base,
                       Thinreports::Layout.new(data_file('layout_text1.tlf'))
  end
end
