# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::List::TestManager < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  List = Thinreports::Core::Shape::List

  def create_report(&block)
    report = Thinreports::Report.new layout: layout_file.path
    block.call(report) if block_given?
    report
  end

  def list_manager
    report = create_report {|r| r.start_new_page }
    report.page.list.manager
  end

  def test_current_page_should_return_the_instance_of_ListPage
    assert_instance_of List::Page, list_manager.current_page
  end

  def test_current_page_state_should_return_the_instance_of_ListPageState
    assert_instance_of List::PageState, list_manager.current_page_state
  end

  def test_switch_current_should_replace_own_current_page_property_by_the_given_page
    report = create_report {|r| r.start_new_page }
    list = report.page.list
    new_page = List::Page.new(report.page, list.internal.format)

    list.manager.switch_current!(new_page)

    assert_same list.manager.current_page, new_page
  end

  def test_switch_current_should_replace_own_current_page_state_property_by_internal_property_of_the_given_page
    report = create_report {|r| r.start_new_page }
    list = report.page.list
    new_page = List::Page.new(report.page, list.internal.format)

    list.manager.switch_current!(new_page)

    assert_same list.manager.current_page_state, new_page.internal
  end

  def test_switch_current_should_return_the_self
    report = create_report {|r| r.start_new_page }
    list = report.page.list
    new_page = List::Page.new(report.page, list.internal.format)

    assert_same list.manager.switch_current!(new_page), list.manager
  end

  def test_page_count
    report = create_report
    assert_equal report.page_count, 0

    report.list.page_break
    report.list.page_break

    assert_equal report.list.manager.page_count, 2
  end
end
