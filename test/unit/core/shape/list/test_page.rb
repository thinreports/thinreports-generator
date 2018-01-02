# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::List::TestPage < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  List = Thinreports::Core::Shape::List

  LIST_SCHEMA = {
    'type' => 'list',
    'id' => 'list',
    'display' => true,
    'x' => 10.0,
    'y' => 20.0,
    'width' => 30.0,
    'height' => 40.0,
    'content-height' => 255,
    'auto-page-break' => true,
    'header' => {
      'enabled' => true,
      'height' => 10.0,
      'translate' => { 'x' => 210.0, 'y' => 310.0 },
      'items' => []
    },
    'detail' => {
      'height' => 20.0,
      'translate' => { 'x' => 220.0, 'y' => 320.0 },
      'items' => []
    },
    'page-footer' => {
      'enabled' => false,
      'height' => 30.0,
      'translate' => { 'x' => 230.0, 'y' => 330.0 },
      'items' => []
    },
    'footer' => {
      'enabled' => false,
      'height' => 40.0,
      'translate' => { 'x' => 240.0, 'y' => 340.0 },
      'items' => []
    }
  }

  def create_report(&block)
    report = Thinreports::Report.new layout: layout_file.path
    block.call(report) if block_given?
    report
  end

  def test_on_page_finalize_callback
    report = create_report
    list = report.list

    counter = 0
    callback = -> { counter += 1 }

    list.on_page_finalize(&callback)

    5.times { list.add_row }
    assert_equal 1, counter

    report.finalize
    assert_equal 2, counter
  end

  def test_on_page_footer_insert_callback
    report = create_report
    list = report.list

    tester = 0
    callback = -> footer {
      assert_instance_of List::SectionInterface, footer
      assert_equal footer.internal.section_name, :page_footer

      tester += 1
    }

    list.on_page_footer_insert(&callback)

    5.times { list.add_row }
    assert_equal 1, tester

    report.finalize
    assert_equal 2, tester
  end

  def test_on_footer_insert_callback
    report = create_report
    list = report.list

    tester = 0
    callback = -> footer {
      assert_instance_of List::SectionInterface, footer
      assert_equal footer.internal.section_name, :footer

      tester += 1
    }

    list.on_footer_insert(&callback)

    5.times { list.add_row }
    assert_equal 0, tester

    report.finalize
    assert_equal 1, tester
  end

  def test_copy_should_properly_work_when_list_has_not_header
    report = Thinreports::Report.new layout: layout_file(schema: LIST_NO_HEADER_SCHEMA_JSON).path

    10.times { report.list.add_row }
  rescue => e
    flunk exception_details(e, 'Not worked when list has not header')
  end

  def test_copy_when_auto_page_break_disabled
    list_schema = LIST_SCHEMA.merge('auto-page-break' => false)

    report = Thinreports::Report::Base.new
    layout = Thinreports::Layout::Base.new(layout_file.path)

    list_format = Thinreports::Core::Shape::List::Format.new(list_schema)

    list_page = List::Page.new(report.page, list_format)

    2.times { list_page.add_row }

    copied_list_page = list_page.copy(Thinreports::Report::Page.new(report, layout))

    assert list_page.manager.finalized?
    assert copied_list_page.manager.finalized?
    assert_equal 2, copied_list_page.internal.rows.count
  end

  def test_copy_when_auto_page_break_enabled
    list_schema = LIST_SCHEMA.merge('auto-page-break' => true)

    report = Thinreports::Report::Base.new
    layout = Thinreports::Layout::Base.new(layout_file.path)

    list_format = Thinreports::Core::Shape::List::Format.new(list_schema)

    list_page = List::Page.new(report.page, list_format)

    2.times { list_page.add_row }
    list_page.manager.finalize_page

    copied_list_page = list_page.copy(Thinreports::Report::Page.new(report, layout))

    refute list_page.manager.finalized?
    refute copied_list_page.manager.finalized?
    assert_empty copied_list_page.internal.rows
  end
end
