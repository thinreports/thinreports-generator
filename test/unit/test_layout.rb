# coding: utf-8

require 'test/unit/helper'

class ThinReports::TestLayout < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def test_new
    flexmock(ThinReports::Layout::Base).should_receive(:new).once
    ThinReports::Layout.new('layout.tlf')
  end
end