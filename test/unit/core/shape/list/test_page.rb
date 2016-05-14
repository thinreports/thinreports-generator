# coding: utf-8

require 'test_helper'

class Thinreports::Core::Shape::List::TestPage < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  List = Thinreports::Core::Shape::List

  def create_report(&block)
    report = Thinreports::Report.new layout: layout_file.path
    block.call(report) if block_given?
    report
  end

  def create_report_for_checking_dispatched_event(event)
    @target_event  = event
    @is_dispatched = false

    create_report do |r|
      r.layout.config.list do |list|
        list.events.on(event) { @is_dispatched = true }
      end
    end
  end

  def assert_dispatched_event
    assert @is_dispatched, "The :#{@target_event} event was not dispatched."
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

  def test_page_finalize_event_should_be_dispatched_when_page_break_is_called
    report = create_report_for_checking_dispatched_event :page_finalize
    report.start_new_page do
      list.page_break
    end

    assert_dispatched_event
  end

  def test_page_finalize_event_should_be_dispatched_when_list_was_overflowed
    report = create_report_for_checking_dispatched_event :page_finalize
    report.start_new_page do
      6.times { list.add_row }
    end

    assert_dispatched_event
  end

  def test_page_finalize_event_should_be_dispatched_when_a_new_page_is_created
    report = create_report_for_checking_dispatched_event :page_finalize
    report.start_new_page do
      list.add_row
    end
    report.start_new_page

    assert_dispatched_event
  end

  def test_page_finalize_event_should_be_dispatched_when_report_is_finalized
    report = create_report_for_checking_dispatched_event :page_finalize
    report.start_new_page do
      list.add_row
    end
    report.finalize

    assert_dispatched_event
  end

  def test_copy_should_properly_work_when_list_has_not_header
    report = Thinreports::Report.new layout: layout_file(schema: LIST_NO_HEADER_SCHEMA_JSON).path

    10.times { report.list.add_row }
  rescue => e
    flunk exception_details(e, 'Not worked when list has not header')
  end
end
