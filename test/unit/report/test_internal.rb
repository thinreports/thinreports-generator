# frozen_string_literal: true

require 'test_helper'

class Thinreports::Report::TestInternal < Minitest::Test
  include Thinreports::TestHelper

  Report = Thinreports::Report

  def setup
    @layout_file = layout_file
  end

  def report
    Report::Base.new
  end

  def test_layout_specified_in_new_method_should_be_defined_as_default_layout
    internal = Report::Internal.new(report, layout: @layout_file.path)
    assert_equal internal.default_layout.filename, @layout_file.path
  end

  def test_register_layout_should_be_set_as_default_layout_when_options_are_omitted
    internal = Report::Internal.new(report, {})
    internal.register_layout(@layout_file.path)

    assert_equal internal.default_layout.filename, @layout_file.path
  end

  def test_register_layout_should_be_set_as_default_layout_when_default_option_is_true
    internal = Report::Internal.new(report, {})
    internal.register_layout(@layout_file.path, default: true)

    assert_equal internal.default_layout.filename, @layout_file.path
  end

  def test_register_layout_should_be_able_to_change_the_default_layout
    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.register_layout(@layout_file.path, default: true)

    assert_equal internal.default_layout.filename, @layout_file.path
  end

  def test_register_layout_should_be_set_as_with_id_when_id_option_is_set
    internal = Report::Internal.new(report, {})
    internal.register_layout(@layout_file.path, id: :foo)

    assert_equal internal.layout_registry[:foo].filename, @layout_file.path
  end

  def test_register_layout_should_raise_an_error_when_id_is_already_registered
    internal = Report::Internal.new(report, {})
    internal.register_layout(@layout_file.path, id: :foo)

    assert_raises ArgumentError do
      internal.register_layout(@layout_file.path, id: :foo)
    end
  end

  def test_add_page_should_finalize_the_current_page
    layout = Thinreports::Layout.new(@layout_file.path)

    internal = Report::Internal.new(report, layout: @layout_file.path)
    page = internal.add_page(Thinreports::Report::Page.new(report, layout))
    internal.add_page(Thinreports::Report::Page.new(report, layout))

    assert_equal page.finalized?, true
  end

  def test_add_page_should_return_the_current_page
    layout = Thinreports::Layout.new(@layout_file.path)
    new_page = Thinreports::Report::Page.new(report, layout)

    internal = Report::Internal.new(report, layout: @layout_file.path)

    assert_same new_page, internal.add_page(new_page)
  end

  def test_add_page_should_add_the_initialized_page
    layout = Thinreports::Layout.new(@layout_file.path)
    new_page = Thinreports::Report::Page.new(report, layout)

    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.add_page(new_page)

    assert_same new_page, internal.pages.last
  end

  def test_add_page_should_count_up_the_total_page_count
    layout = Thinreports::Layout.new(@layout_file.path)

    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.add_page(Thinreports::Report::Page.new(report, layout))

    assert_equal internal.page_count, 1
  end

  def test_add_page_should_switch_to_a_reference_to_the_current_page
    layout = Thinreports::Layout.new(@layout_file.path)
    new_pages = (1..2).inject([]) do |pages|
      pages << Thinreports::Report::Page.new(report, layout)
    end

    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.add_page(new_pages[0])

    assert_same internal.page, new_pages[0]

    internal.add_page(new_pages[1])

    assert_same internal.page, new_pages[1]
  end

  def test_add_blank_page_should_not_count_up_the_total_page_count_when_count_is_disabled
    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.add_page(Thinreports::Report::BlankPage.new(false))

    assert_equal internal.page_count, 0
  end

  def test_add_blank_page_should_count_up_the_total_page_count_when_count_is_enabled
    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.add_page(Thinreports::Report::BlankPage.new)

    assert_equal internal.page_count, 1
  end

  def test_finalize_should_finalize_the_report
    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.finalize

    assert internal.finalized?
  end

  def test_finalize_should_not_work_when_report_is_already_finalized
    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.finalize

    # #finalize_current_page must never be called
    internal.expects(:finalize_current_page).never
    internal.finalize
  end

  def test_finalized_should_return_true_when_report_is_already_finalized
    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.finalize

    assert internal.finalized?
  end

  def test_load_layout_with_String
    internal = Report::Internal.new(report, layout: @layout_file.path)

    assert_equal internal.load_layout(@layout_file.path).filename,
                 @layout_file.path
  end

  def test_load_layout_with_id
    internal = Report::Internal.new(report, {})
    internal.register_layout(@layout_file.path, id: :sample)

    assert_equal internal.load_layout(:sample).filename,
                 @layout_file.path
  end

  def test_load_layout_with_unknown_id
    internal = Report::Internal.new(report, {})
    assert_nil internal.load_layout(:unknown)
  end

  def test_load_layout_should_set_default_layout_when_default_layout_is_nil
    internal = Report::Internal.new(report, {})
    internal.load_layout(@layout_file.path)

    assert_equal internal.default_layout.filename,
                 @layout_file.path
  end

  def test_load_layout_should_raise_error_when_invalid_value_set
    internal = Report::Internal.new(report, {})

    assert_raises Thinreports::Errors::LayoutFileNotFound do
      internal.load_layout('/path/to/unkown.tlf')
    end
  end

  def test_copy_page_should_finalize_current_page
    layout = Thinreports::Layout.new(@layout_file.path)

    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.add_page(page = Thinreports::Report::Page.new(report, layout))
    internal.copy_page

    assert page.finalized?
  end

  def test_copy_page_should_add_the_copied_page
    layout = Thinreports::Layout.new(@layout_file.path)

    internal = Report::Internal.new(report, layout: @layout_file.path)
    internal.add_page(Thinreports::Report::Page.new(report, layout))
    internal.copy_page

    assert_equal internal.page_count, 2
  end
end
