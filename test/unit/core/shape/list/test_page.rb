# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestPage < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  List = ThinReports::Core::Shape::List
  
  def create_report(&block)
    create_basic_report('basic_list_layout.tlf', &block)
  end
  
  def create_report_for_checking_dispatched_event(event)
    @target_event  = event
    @is_dispatched = false
    
    create_report do |r|
      r.layout.config.list(:list) do |list|
        list.events.on(event) {|e| @is_dispatched = true }
      end
    end
  end
  
  def assert_dispatched_event
    assert @is_dispatched, "The :#{@target_event} event was not dispatched."
  end
  
  def test_page_finalize_event_should_be_dispatched_when_page_break_is_called
    report = create_report_for_checking_dispatched_event :page_finalize
    report.start_new_page do
      list(:list).page_break
    end
    
    assert_dispatched_event
  end
  
  def test_page_finalize_event_should_be_dispatched_when_list_was_overflowed
    report = create_report_for_checking_dispatched_event :page_finalize
    report.start_new_page do
      6.times { list(:list).add_row }
    end
    
    assert_dispatched_event
  end
  
  def test_page_finalize_event_should_be_dispatched_when_a_new_page_is_created
    report = create_report_for_checking_dispatched_event :page_finalize
    report.start_new_page do
      list(:list).add_row
    end
    report.start_new_page
    
    assert_dispatched_event
  end
  
  def test_page_finalize_event_should_be_dispatched_when_report_is_finalized
    report = create_report_for_checking_dispatched_event :page_finalize
    report.start_new_page do
      list(:list).add_row
    end
    report.finalize
    
    assert_dispatched_event
  end
  
  def test_copy_should_properly_work_when_list_has_not_header
    report = create_basic_report('basic_list_noheader_layout.tlf')
    
    10.times {|t| report.list.add_row }
  rescue => e
    flunk exception_details(e, 'Not worked when list has not header')
  end
end