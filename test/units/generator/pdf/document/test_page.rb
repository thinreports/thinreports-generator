# frozen_string_literal: true

require 'test_helper'

class Thinreports::Generator::PDF::Document::TestPage < Minitest::Test
  include Thinreports::TestHelper

  def create_pdf
    @pdf = Thinreports::Generator::PDF::Document.new
  end

  def test_JIS_page_size
    sizes = Thinreports::Generator::PDF::Document::JIS_SIZES
    assert_equal sizes['B4'], [728.5, 1031.8]
    assert_equal sizes['B5'], [515.9, 728.5]
  end

  def test_B4_paper_size_should_returns_size_as_B4_JIS
    create_pdf

    format = Thinreports::Layout::Format.build(layout_file.path)
    format.stubs(page_paper_type: 'B4')

    @pdf.start_new_page(format)
    assert_equal @pdf.internal.page.size, [728.5, 1031.8]
  end

  def test_B4_ISO_paper_size_should_be_converted_to_B4
    create_pdf

    format = Thinreports::Layout::Format.build(layout_file.path)
    format.stubs(page_paper_type: 'B4_ISO')

    @pdf.start_new_page(format)
    assert_equal @pdf.internal.page.size, 'B4'
  end

  def test_change_page_format_should_return_true_at_first_time
    create_pdf
    format = Thinreports::Layout::Format.build(layout_file.path)

    assert_equal @pdf.send(:change_page_format?, format), true
  end

  def test_change_page_format_should_return_false_when_given_the_same_format
    create_pdf
    format = Thinreports::Layout::Format.build(layout_file.path)

    @pdf.instance_variable_set(:@current_page_format, format)
    assert_equal @pdf.send(:change_page_format?, format), false
  end

  def test_change_page_format_should_return_true_when_given_the_other_format
    create_pdf
    format1 = Thinreports::Layout::Format.build(layout_file.path)
    format2 = Thinreports::Layout::Format.build(layout_file.path)

    @pdf.instance_variable_set(:@current_page_format, format1)
    assert_equal @pdf.send(:change_page_format?, format2), true
  end

  def test_new_basic_page_options
    format = Thinreports::Layout::Format.build(layout_file.path)
    options = create_pdf.send(:new_basic_page_options, format)

    assert_equal options[:layout], format.page_orientation.to_sym
    assert_equal options[:size], format.page_paper_type
  end

  def test_new_basic_page_options_when_the_layout_has_customize_size
    format = stub user_paper_type?: true,
                  page_width: 100,
                  page_height: 100,
                  page_orientation: 'portrait'

    options = create_pdf.send(:new_basic_page_options, format)
    assert_equal options[:size], [100, 100]
  end

  def test_start_new_page_should_create_stamp
    create_pdf
    format = Thinreports::Layout::Format.build(layout_file.path)
    @pdf.start_new_page(format)

    assert_includes @pdf.send(:format_stamp_registry), format.identifier
  end

  def test_start_new_page_should_not_create_stamp
    create_pdf
    format = Thinreports::Layout::Format.build(layout_file.path)
    @pdf.start_new_page(format)
    @pdf.start_new_page(format)

    assert_equal @pdf.send(:format_stamp_registry).size, 1
  end

  def test_start_new_page_should_stamp_constantly
    create_pdf
    format = Thinreports::Layout::Format.build(layout_file.path)
    @pdf.expects(:stamp).with(format.identifier.to_s).times(2)

    @pdf.start_new_page(format)
    @pdf.start_new_page(format)
  end

  def test_add_blank_page_should_create_an_A4_size_page_in_first_page
    create_pdf
    @pdf.internal.expects(:start_new_page).with(size: 'A4').once

    @pdf.add_blank_page
  end

  def test_add_blank_page_should_call_with_no_arguments_since_second_page
    create_pdf
    format = Thinreports::Layout::Format.build(layout_file.path)

    @pdf.start_new_page(format)
    @pdf.internal.expects(:start_new_page).with({}).once

    @pdf.add_blank_page
  end
end
