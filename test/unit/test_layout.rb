# coding: utf-8

require 'test_helper'

class ThinReports::TestLayout < Minitest::Test
  include ThinReports::TestHelper

  def test_new
    assert_instance_of ThinReports::Layout::Base,
                       ThinReports::Layout.new(data_file('layout_text1.tlf'))
  end
end
