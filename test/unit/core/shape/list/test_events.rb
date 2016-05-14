# coding: utf-8

require 'test_helper'

class Thinreports::Core::Shape::List::TestEvents < Minitest::Test
  include Thinreports::TestHelper

  List = Thinreports::Core::Shape::List

  def setup
    @events = List::Events.new
  end

  def test_page_footer_insert_event_should_be_able_to_be_used
    @events.send(:verify_event_type, :page_footer_insert)
  rescue Thinreports::Errors::UnknownEventType
    flunk ':page_footer_insert cannot be used.'
  end
  
  def test_footer_insert_event_should_be_able_to_be_used
    @events.send(:verify_event_type, :footer_insert)
  rescue Thinreports::Errors::UnknownEventType
    flunk ':footer_insert cannot be used.'
  end

  def test_page_finalize_event_should_be_able_to_be_used
    @events.send(:verify_event_type, :page_finalize)
  rescue Thinreports::Errors::UnknownEventType
    flunk ':page_finalize cannot be used.'
  end

  def test_list_property_of_PageEvent_should_equal_to_target_property
    ev = List::Events::PageEvent.new(:page_finalize, 'list', 'page')
    assert_same ev.list, ev.target
  end
end
