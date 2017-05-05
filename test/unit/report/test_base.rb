# frozen_string_literal: true

require 'test_helper'

class Thinreports::Report::TestBase < Minitest::Test
  include Thinreports::TestHelper

  Report = Thinreports::Report

  def setup
    @report = Report::Base.new
    @layout_file = layout_file
  end

  def test_on_page_create_callback
    report = Report::Base.new layout: @layout_file.path

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
    report = Report::Base.new layout: @layout_file.path
    assert_equal report.default_layout.filename, @layout_file.path
  end

  def test_initialize_should_initialize_new_Report_without_default_layout
    assert_nil @report.default_layout
  end

  def test_use_layout_should_register_default_layout_when_default_property_is_omitted
    @report.use_layout(@layout_file.path)

    assert_equal @report.default_layout.filename, @layout_file.path
  end

  def test_use_layout_should_register_default_layout_when_default_property_is_true
    @report.use_layout(@layout_file.path, default: true)

    assert_equal @report.default_layout.filename, @layout_file.path
  end

  def test_start_new_page_should_properly_create_a_new_Page_and_return
    @report.use_layout(@layout_file.path)

    assert_instance_of Thinreports::Report::Page, @report.start_new_page
  end

  def test_start_new_page_should_raise_when_the_layout_has_not_been_registered_yet
    assert_raises Thinreports::Errors::NoRegisteredLayoutFound do
      @report.start_new_page(layout: :unknown)
    end
  end

  def test_start_new_page_should_create_a_new_page_using_a_default_layout
    @report.use_layout(@layout_file.path, default: true)

    assert_equal @report.start_new_page.layout.filename, @layout_file.path
  end

  def test_start_new_page_should_create_a_new_page_using_a_layout_with_specified_id
    @report.use_layout(@layout_file.path, id: :foo)

    assert_equal @report.start_new_page(layout: :foo).layout.filename,
                 @layout_file.path
  end

  def test_start_new_page_should_create_a_new_page_using_a_specified_layoutfile
    new_page = @report.start_new_page(layout: @layout_file.path)
    assert_equal new_page.layout.filename, @layout_file.path
  end

  def test_start_new_page_with_count_option
    @report.use_layout @layout_file.path, default: true

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
    @report.use_layout(@layout_file.path)

    assert_instance_of Thinreports::Report::BlankPage, @report.add_blank_page
  end

  def test_layout_should_return_the_default_layout_with_no_arguments
    @report.use_layout(@layout_file.path, default: true)

    assert_equal @report.layout.filename, @layout_file.path
  end

  def test_layout_should_raise_when_the_specified_layout_is_not_found
    assert_raises Thinreports::Errors::UnknownLayoutId do
      @report.layout(:unknown_layout_id)
    end
  end

  def test_layout_should_return_the_layout_with_specified_id
    @report.use_layout(@layout_file.path, id: :foo)

    assert_equal @report.layout(:foo).filename, @layout_file.path
  end

  def test_generate
    report = Report::Base.new(layout: @layout_file.path)

    generator = mock('generator')
    generator.expects(:generate).with('result.pdf')

    Thinreports::Generator::PDF.expects(:new)
      .with(report, { security: { owner_password: 'pass' }})
      .returns(generator)

    report.generate(
      filename: 'result.pdf',
      security: { owner_password: 'pass' }
    )
  end

  def test_page_should_return_the_current_page
    @report.use_layout(@layout_file.path)
    @report.start_new_page

    assert_instance_of Thinreports::Report::Page, @report.page
  end

  def test_page_count_should_return_total_page_count
    @report.use_layout(@layout_file.path)
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
    @report.use_layout(@layout_file.path)
    @report.list

    refute_nil @report.page
  end

  def test_list_should_create_new_page_when_page_is_finalized
    @report.tap do |r|
      r.use_layout(@layout_file.path)
      r.start_new_page
      r.page.finalize
    end
    @report.list

    assert_equal @report.page.finalized?, false
  end

  def test_list_should_properly_return_shape_with_the_specified_id
    @report.use_layout(@layout_file.path)

    assert_equal @report.list.id, 'default'
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

  def test_Base_generate_should_raise_when_no_block_given
    assert_raises ArgumentError do
      Report::Base.generate(:pdf)
    end
  end

  def test_Base_generate_with_deprecated_arguments
    Report::Base.expects(:create).with(layout: '/path/to/layout.tlf').returns(@report)
    @report.expects(:generate).with(
      filename: 'result.pdf',
      security: { owner_password: 'pass' }
    )

    Report::Base.generate(
      report: { layout: '/path/to/layout.tlf' },
      generator: {
        filename: 'result.pdf',
        security: { owner_password: 'pass' }
      }
    ) { |_| }
  end

  def test_Base_generate_argument_priority
    Report::Base.expects(:create).with(layout: '/path/to/layout.tlf').returns(@report)
    @report.expects(:generate).with(
      filename: 'result.pdf',
      security: { owner_password: 'pass' }
    )

    Report::Base.generate(
      layout: '/path/to/layout.tlf',
      filename: 'result.pdf',
      security: { owner_password: 'pass' },
      report: { layout: '/path/to/deprecated.tlf' },
      generator: {
        filename: 'deprecated.pdf',
        security: { owner_password: 'deprecated' }
      }
    ) { |_| }
  end
end
