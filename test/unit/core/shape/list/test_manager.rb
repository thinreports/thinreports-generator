# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestManager < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  List = ThinReports::Core::Shape::List
  
  def create_report(&block)
    create_basic_report('basic_list_layout.tlf', &block)
  end
  
  def list_manager
    report = create_report {|r| r.start_new_page }
    report.page.list(:list).manager
  end
  
  def test_config_should_return_the_instance_of_ListConfiguration
    assert_same list_manager.config.class, List::Configuration
  end
  
  def test_current_page_should_return_the_instance_of_ListPage
    assert_instance_of List::Page, list_manager.current_page
  end
  
  def test_current_page_state_should_return_the_instance_of_ListPageState
    assert_instance_of List::PageState, list_manager.current_page_state
  end
  
  def test_switch_current_should_replace_own_current_page_property_by_the_given_page
    report = create_report {|r| r.start_new_page }
    list   = report.page.list(:list)
    new_page = List::Page.new(report.page, list.internal.format)
    
    list.manager.switch_current!(new_page)
    
    assert_same list.manager.current_page, new_page
  end
  
  def test_switch_current_should_replace_own_current_page_state_property_by_internal_property_of_the_given_page
    report = create_report {|r| r.start_new_page }
    list   = report.page.list(:list)
    new_page = List::Page.new(report.page, list.internal.format)
    
    list.manager.switch_current!(new_page)
    
    assert_same list.manager.current_page_state, new_page.internal
  end
  
  def test_switch_current_should_return_the_self
    report = create_report {|r| r.start_new_page }
    list   = report.page.list(:list)
    new_page = List::Page.new(report.page, list.internal.format)
    
    assert_same list.manager.switch_current!(new_page), list.manager
  end
  
  def test_finalize_page_should_dispatch_page_finalize_event
    flag = false
    
    report = create_report do |r|
      r.layout.config.list(:list) do
        events.on :page_finalize do |e|
          flag = true
        end
      end
    end
    
    report.start_new_page do |page|
      page.list(:list).manager.finalize_page
    end
    
    assert flag, 'The :page_finalize event was not dispatched.'
  end
  
  def test_page_property_which_dispatcher_of_finalize_page_event_should_return_the_current_page
    page_used_in_event = nil
    
    report = create_report do |r|
      r.layout.config.list(:list) do
        events.on :page_finalize do |e|
          page_used_in_event = e.page
        end
      end
    end
    
    current_page = report.start_new_page
    current_page.list(:list).manager.finalize_page
    
    assert_same page_used_in_event, current_page
  end
  
  def test_list_property_which_dispatcher_of_finalize_event_should_return_the_current_page_of_list
    list_used_in_event = nil
    
    report = create_report do |r|
      r.layout.config.list(:list) do
        events.on :page_finalize do |e|
          list_used_in_event = e.list
        end
      end
    end
    
    report.start_new_page
    current_list = report.page.list(:list)
    current_list.manager.finalize_page
    
    assert_same list_used_in_event, current_list
  end
end
