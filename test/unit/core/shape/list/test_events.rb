# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestEvents < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  List = ThinReports::Core::Shape::List
  
  def setup
    @events = List::Events.new
  end
  
  def test_allowed_event_types
    assert_equal @events.instance_variable_get(:@types),
                 [:page_footer_insert, :footer_insert]
  end
  
  def test_SectionEvent
    e = List::Events::SectionEvent.new(:section_event,
                                       :target,
                                       :store)
    assert_equal e.type, :section_event
    assert_equal e.target, :target
    assert_equal e.section, :target
    assert_equal e.store, :store
  end
end