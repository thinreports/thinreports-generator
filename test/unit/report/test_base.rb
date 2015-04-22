# coding: utf-8

require 'test_helper'

class Thinreports::Report::TestBase < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Report = Thinreports::Report

  def setup
    @report = Report::Base.new
  end

  def test_on_page_create_callback
    report = Report::Base.new layout: data_file('layout_text1.tlf')

    counter = 0
    callback = -> page {
      assert_instance_of Report::Page, page
      counter += 1
    }

    report.on_page_create(&callback)

    2.times { report.start_new_page }
    assert_equal counter, 2
  end

  def test_initialize_should_register_layout_as_default_when_layout_is_specified_as_the_option
    report = Report::Base.new layout: data_file('layout_text1.tlf')
    assert_equal report.default_layout.filename, data_file('layout_text1.tlf')
  end

  def test_initialize_should_initialize_new_Report_without_default_layout
    assert_nil @report.default_layout
  end

  def test_use_layout_should_register_default_layout_when_default_property_is_omitted
    @report.use_layout(data_file('layout_text1.tlf'))

    assert_equal @report.default_layout.filename, data_file('layout_text1.tlf')
  end

  def test_use_layout_should_register_default_layout_when_default_property_is_true
    @report.use_layout(data_file('layout_text2.tlf'), default: true)

    assert_equal @report.default_layout.filename, data_file('layout_text2.tlf')
  end

  def test_start_new_page_should_properly_create_a_new_Page_and_return
    @report.use_layout(data_file('layout_text1'))

    assert_instance_of Thinreports::Report::Page, @report.start_new_page
  end

  def test_start_new_page_should_raise_when_the_layout_has_not_been_registered_yet
    assert_raises Thinreports::Errors::NoRegisteredLayoutFound do
      @report.start_new_page(layout: :unknown)
    end
  end

  def test_start_new_page_should_create_a_new_page_using_a_default_layout
    @report.use_layout(data_file('layout_text1.tlf'), default: true)

    assert_equal @report.start_new_page.layout.filename, data_file('layout_text1.tlf')
  end

  def test_start_new_page_should_create_a_new_page_using_a_layout_with_specified_id
    @report.use_layout(data_file('layout_text1.tlf'), id: :foo)

    assert_equal @report.start_new_page(layout: :foo).layout.filename,
                 data_file('layout_text1.tlf')
  end

  def test_start_new_page_should_create_a_new_page_using_a_specified_layoutfile
    new_page = @report.start_new_page(layout: data_file('layout_text1.tlf'))
    assert_equal new_page.layout.filename, data_file('layout_text1.tlf')
  end

  def test_start_new_page_with_count_option
    @report.use_layout data_file('layout_text1.tlf'), default: true

    new_page = @report.start_new_page count: false
    assert_nil new_page.no
    assert_equal @report.page_count, 0

    new_page = @report.start_new_page count: true
    assert_equal new_page.no, 1
    assert_equal @report.page_count, 1

    new_page = @report.start_new_page
    assert_equal new_page.no, 2
    assert_equal @report.page_count, 2
  end

  def test_add_blank_page_should_properly_create_a_new_blank_page
    @report.use_layout(data_file('layout_text1'))

    assert_instance_of Thinreports::Report::BlankPage, @report.add_blank_page
  end

  def test_layout_should_return_the_default_layout_with_no_arguments
    @report.use_layout(data_file('layout_text1.tlf'), default: true)

    assert_equal @report.layout.filename, data_file('layout_text1.tlf')
  end

  def test_layout_should_raise_when_the_specified_layout_is_not_found
    assert_raises Thinreports::Errors::UnknownLayoutId do
      @report.layout(:unknown_layout_id)
    end
  end

  def test_layout_should_return_the_layout_with_specified_id
    @report.use_layout(data_file('layout_text2.tlf'), id: :foo)

    assert_equal @report.layout(:foo).filename, data_file('layout_text2.tlf')
  end

  def test_generate_with_filename
    report = Report::Base.new layout: data_file('layout_text1.tlf')

    report.generate :pdf, filename: temp_path.join('result1.pdf')
    report.generate filename: temp_path.join('result2.pdf')

    assert File.exists?(temp_path.join('result1.pdf'))
    assert File.exists?(temp_path.join('result2.pdf'))

    assert_equal File.read(temp_path.join('result1.pdf')),
                 File.read(temp_path.join('result2.pdf'))
  end

  def test_events_should_return_Report_Events
    assert_instance_of Thinreports::Report::Events, @report.events
  end

  def test_events_should_deprecated
    out, err = capture_io do
      @report.events
    end
    assert_includes err, '[DEPRECATION]'
  end

  def test_page_should_return_the_current_page
    @report.use_layout(data_file('layout_text1.tlf'))
    @report.start_new_page

    assert_instance_of Thinreports::Report::Page, @report.page
  end

  def test_page_count_should_return_total_page_count
    @report.use_layout(data_file('layout_text1.tlf'))
    2.times { @report.start_new_page }

    assert_equal @report.page_count, 2
  end

  def test_finalize_should_finalize_report
    @report.finalize
    assert_equal @report.finalized?, true
  end

  def test_finalized_asker_should_return_false_when_report_has_not_been_finalized_yet
    assert_equal @report.finalized?, false
  end

  def test_finalized_asker_should_return_true_when_report_is_already_finalized
    @report.finalize
    assert_equal @report.finalized?, true
  end

  def test_list_should_create_new_page_when_page_is_not_created
    @report.use_layout(data_file('layout_list.tlf'))
    @report.list(:list)

    refute_nil @report.page
  end

  def test_list_should_create_new_page_when_page_is_finalized
    @report.tap do |r|
      r.use_layout(data_file('layout_list.tlf'))
      r.start_new_page
      r.page.finalize
    end
    @report.list(:list)

    assert_equal @report.page.finalized?, false
  end

  def test_list_should_properly_return_shape_with_the_specified_id
    @report.use_layout(data_file('layout_list.tlf'))

    assert_equal @report.list(:list).id, 'list'
  end

  def test_start_page_number
    assert_equal @report.start_page_number, 1
    @report.start_page_number_from 10
    assert_equal @report.start_page_number, 10
  end

  def test_Base_create_should_finalize_report
    report = Report::Base.create do |r|
      assert_instance_of Report::Base, r
    end
    assert_equal report.finalized?, true
  end

  def test_Base_create_should_raise_when_no_block_given
    assert_raises ArgumentError do
      Report::Base.create
    end
  end

  def test_Base_generate_with_filename
    layout_file = data_file 'layout_text1.tlf'

    Report::Base.generate(:pdf, report: { layout: layout_file },
                          generator: { filename: temp_path.join('result1.pdf') }) {}
    Report::Base.generate(report: { layout: layout_file },
                          generator: { filename: temp_path.join('result2.pdf') }) {}

    assert_equal temp_path.join('result1.pdf').read,
                 temp_path.join('result2.pdf').read
  end

  def test_Base_generate_should_raise_when_no_block_given
    assert_raises ArgumentError do
      Report::Base.generate(:pdf)
    end
  end

  def test_Base_extract_options_should_return_as_report_option_the_value_which_has_report_in_a_key
    report, generator = Report::Base.send(:extract_options!, [{report: {layout: 'hoge.tlf'}}])
    assert_equal report[:layout], 'hoge.tlf'
  end

  def test_Base_extract_options_should_operate_an_argument_destructively
    args = [:pdf, 'output.pdf', {report: {layout: 'foo.tlf'}}]
    Report::Base.send(:extract_options!, args)
    assert_equal args, [:pdf, 'output.pdf']
  end

  def test_Base_extract_options_should_include_the_layout_key_in_the_report_option
    report, generator = Report::Base.send(:extract_options!, [{layout: 'hoge.tlf'}])
    assert_equal report[:layout], 'hoge.tlf'
  end

  def test_Base_extract_options_should_give_priority_to_the_value_of_the_layout_key_over_in_the_report_option
    report, generator = Report::Base.send(:extract_options!,
                                          [{report: {layout: 'foo.tlf'}, layout: 'hoge.tlf'}])
    assert_equal report[:layout], 'hoge.tlf'
  end

  def test_Base_extract_options_should_return_as_generator_option_the_value_which_has_generator_in_a_key
    report, generator = Report::Base.send(:extract_options!,
                                          [{generator: {option: 'value'}}])
    assert_equal generator[:option], 'value'
  end

  def test_Base_extract_options_should_give_priority_to_the_value_of_other_keys_over_in_the_generator_option
    report, generator = Report::Base.send(:extract_options!,
                                          [{generator: {option: 'value1'}, option: 'value2'}])
    assert_equal generator[:option], 'value2'
  end

  def test_Base_extract_options_should_return_all_the_values_except_the_report_option_as_a_generator_option
    report, generator = Report::Base.send(:extract_options!,
                                          [{report: {layout: 'foo.tlf'}, layout: 'hoge.tlf',
                                            generator_opt1: 'value1', generator_opt2: 'value2'}])
    assert_equal generator.values_at(:generator_opt1, :generator_opt2),
                 ['value1', 'value2']
  end
end
