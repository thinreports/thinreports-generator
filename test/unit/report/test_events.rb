# coding: utf-8

require 'test/unit/helper'

class ThinReports::Report::TestEvents < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Report = ThinReports::Report
  
  def test_event_types
    events = Report::Events.new
    assert_equal events.instance_variable_get(:@types), [:page_create, :generate]
  end
  
  def test_event_properly_store_the_properties
    e = Report::Events::Event.new(:page_create, :target, :page, :pages)
    assert_equal [e.type, e.target, e.page, e.pages],
                 [:page_create, :target, :page, :pages]
    assert_same e.target, e.report
  end
end
