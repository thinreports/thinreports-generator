# coding: utf-8

require 'test/unit/helper'

class ThinReports::Report::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Report = ThinReports::Report
  
  def report
    Report::Base.new
  end

  def sample_layout1
    data_file('basic_layout1.tlf')
  end

  def sample_layout2
    data_file('basic_layout2.tlf')
  end

  def test_layout_specified_in_new_method_should_be_defined_as_default_layout
    internal = Report::Internal.new(report, :layout => sample_layout1)
    assert_equal internal.default_layout.filename, sample_layout1
  end

  def test_register_layout_should_be_set_as_default_layout_when_options_are_omitted
    internal = Report::Internal.new(report, {})
    internal.register_layout(sample_layout1)

    assert_equal internal.default_layout.filename, sample_layout1
  end
  
  def test_register_layout_should_be_set_as_default_layout_when_default_option_is_true
    internal = Report::Internal.new(report, {})
    internal.register_layout(sample_layout1, :default => true)
    
    assert_equal internal.default_layout.filename, sample_layout1
  end
  
  def test_register_layout_should_be_able_to_change_the_default_layout
    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.register_layout(sample_layout2, :default => true)

    assert_equal internal.default_layout.filename, sample_layout2
  end
  
  def test_register_layout_should_be_set_as_with_id_when_id_option_is_set
    internal = Report::Internal.new(report, {})
    internal.register_layout(sample_layout1, :id => :foo)

    assert_equal internal.layout_registry[:foo].filename, sample_layout1
  end
  
  def test_register_layout_should_raise_an_error_when_id_is_already_registered
    internal = Report::Internal.new(report, {})
    internal.register_layout(sample_layout2, :id => :foo)
    
    assert_raises ArgumentError do
      internal.register_layout(sample_layout1, :id => :foo)
    end
  end
  
  def test_register_layout_should_return_the_instance_of_LayoutConfiguration
    internal = Report::Internal.new(report, {})

    assert_instance_of ThinReports::Layout::Configuration, 
                       internal.register_layout(sample_layout1)
  end
  
  def test_add_page_should_finalize_the_current_page
    layout = ThinReports::Layout.new(sample_layout1)

    internal = Report::Internal.new(report, :layout => sample_layout1)
    page = internal.add_page(ThinReports::Core::Page.new(report, layout))
    internal.add_page(ThinReports::Core::Page.new(report, layout))

    assert_equal page.finalized?, true
  end

  def test_add_page_should_return_the_current_page
    layout = ThinReports::Layout.new(sample_layout1)
    new_page = ThinReports::Core::Page.new(report, layout)

    internal = Report::Internal.new(report, :layout => sample_layout1)

    assert_same new_page, internal.add_page(new_page)
  end

  def test_add_page_should_add_the_initialized_page
    layout = ThinReports::Layout.new(sample_layout1)
    new_page = ThinReports::Core::Page.new(report, layout)

    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.add_page(new_page)

    assert_same new_page, internal.pages.last
  end

  def test_add_page_should_count_up_the_total_page_count
    layout = ThinReports::Layout.new(sample_layout1)
    
    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.add_page(ThinReports::Core::Page.new(report, layout))

    assert_equal internal.page_count, 1
  end
  
  def test_add_page_should_switch_to_a_reference_to_the_current_page
    layout = ThinReports::Layout.new(sample_layout1)
    new_pages = (1..2).inject([]) do |pages, i|
      pages << ThinReports::Core::Page.new(report, layout)
    end

    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.add_page(new_pages[0])

    assert_same internal.page, new_pages[0]

    internal.add_page(new_pages[1])

    assert_same internal.page, new_pages[1]
  end
    
  def test_add_page_should_dispatch_the_event_page_creation
    dispatched = false
    layout = ThinReports::Layout.new(sample_layout1)

    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.events.on(:page_create) {|e| dispatched = true }
    internal.add_page(ThinReports::Core::Page.new(report, layout))

    assert dispatched
  end

  def test_add_blank_page_should_not_dispatch_the_event_page_creation
    dispatched = false
    layout = ThinReports::Layout.new(sample_layout1)

    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.events.on(:page_create) {|e| dispatched = true }
    internal.add_page(ThinReports::Core::BlankPage.new)

    refute dispatched
  end
  
  def test_add_blank_page_should_not_count_up_the_total_page_count_when_count_is_disabled
    layout = ThinReports::Layout.new(sample_layout1)

    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.add_page(ThinReports::Core::BlankPage.new(false))

    assert_equal internal.page_count, 0
  end

  def test_add_blank_page_should_count_up_the_total_page_count_when_count_is_enabled
    layout = ThinReports::Layout.new(sample_layout1)

    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.add_page(ThinReports::Core::BlankPage.new)

    assert_equal internal.page_count, 1
  end
  
  def test_finalize_should_dispatch_the_event_report_generation
    dispatched = false

    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.events.on(:generate) {|e| dispatched = true }
    internal.finalize

    assert dispatched
  end

  def test_finalize_should_finalize_the_report
    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.finalize

    assert internal.finalized?
  end

  def test_finalize_should_not_work_when_report_is_already_finalized
    internal = Report::Internal.new(report, :layout => sample_layout1)

    flexmock(internal).
      should_receive(:finalize_current_page).once

    internal.finalize
    internal.finalize
  end

  def test_finalized_should_return_true_when_report_is_already_finalized
    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.finalize

    assert internal.finalized?
  end
  
  def test_load_layout_with_String
    internal = Report::Internal.new(report, :layout => sample_layout1)
    
    assert_equal internal.load_layout(sample_layout2).filename, 
                 sample_layout2
  end
  
  def test_load_layout_with_id
    internal = Report::Internal.new(report, {})
    internal.register_layout(sample_layout1, :id => :sample)

    assert_equal internal.load_layout(:sample).filename, 
                 sample_layout1
  end
  
  def test_load_layout_with_unknown_id
    internal = Report::Internal.new(report, {})
    assert_nil internal.load_layout(:unknown)
  end
  
  def test_load_layout_should_raise_error_when_invalid_value_set
    internal = Report::Internal.new(report, {})

    assert_raises ThinReports::Errors::LayoutFileNotFound do
      internal.load_layout('/path/to/unkown.tlf')
    end
  end
  
  def test_copy_page_should_finalize_current_page
    layout = ThinReports::Layout.new(sample_layout1)

    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.add_page(page = ThinReports::Core::Page.new(report, layout))
    internal.copy_page

    assert page.finalized?
  end

  def test_copy_page_should_add_the_copied_page
    layout = ThinReports::Layout.new(sample_layout1)

    internal = Report::Internal.new(report, :layout => sample_layout1)
    internal.add_page(page = ThinReports::Core::Page.new(report, layout))
    internal.copy_page

    assert_equal internal.page_count, 2
  end
end
