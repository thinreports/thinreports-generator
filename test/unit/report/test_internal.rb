# coding: utf-8

require 'test/unit/helper'

class ThinReports::Report::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Report = ThinReports::Report
  
  def setup
    # Setting for instance of Layout::Base as mock.
    layout = flexmock('layout_base')
    layout.should_receive(:config).and_return(flexmock('layout_configuration'))
    
    flexmock(ThinReports::Layout).
      should_receive(:new).and_return(layout)
  end
  
  def test_initialize_with_default_layout
    report = init_report(:layout => 'default.tlf')
    assert_equal report.default_layout.flexmock_name, 'layout_base'
  end
  
  def test_register_layout_properly_set_the_default_layout
    report = init_report
    report.register_layout('default.tlf')
    
    assert_equal report.default_layout.flexmock_name, 'layout_base'
  end
  
  def test_register_layout_properly_set_the_default_layout_with_option
    report = init_report
    report.register_layout('default.tlf', :default => true)
    
    assert_equal report.default_layout.flexmock_name, 'layout_base'
  end
  
  def test_register_layout_raise_when_default_layout_is_already_set
    assert_raises ArgumentError do
      init_report(:layout => 'default.tlf').register_layout('other.tlf')
    end
  end
  
  def test_register_layout_properly_set_the_layout
    report = init_report
    report.register_layout('foo.tlf', :id => :foo)
    
    assert_equal report.layout_registry[:foo].flexmock_name, 'layout_base'
  end
  
  def test_register_layout_raise_when_specified_id_is_already_registered
    report = init_report
    report.register_layout('foo.tlf', :id => :foo)
    
    assert_raises ArgumentError do
      report.register_layout('hoge.tlf', :id => :foo)
    end
  end
  
  def test_register_layout_call_layout_config_method_with_block
    report = init_report
    assert_equal report.register_layout('layout.tlf').flexmock_name,
                 'layout_configuration'
  end
  
  def test_add_page_count_up_the_page_count
    new_page = proc {
      mock_page.should_receive(:finalize).mock
    }
    
    report = init_report
    assert_equal report.page_count, 0
    
    report.add_page(new_page.call)
    assert_equal report.page_count, 1

    report.add_page(new_page.call)    
    assert_equal report.page_count, 2
  end
  
  def test_add_page_finalize_current_page
    report = init_report
    
    report.add_page(mock_page.should_receive(:finalize).once.mock)
    report.add_page(mock_page)
  end
  
  def test_add_page_switch_currently_page_of_report
    new_page = proc {|name|
      mock_page(name).should_receive(:finalize).mock
    }
    
    report = init_report
    
    report.add_page(new_page.call('page1'))
    assert_equal report.page.flexmock_name, 'page1'
    
    report.add_page(new_page.call('page2'))
    assert_equal report.page.flexmock_name, 'page2'
  end
  
  def test_add_page_store_specified_page_to_report_pages
    report = init_report
    report.add_page(new_page = mock_page)
    
    assert_includes report.pages, new_page
  end
  
  def test_add_page_dispatch_the_page_create_event
    pass   = false
    report = init_report
    report.events.on(:page_create) {|e| pass = true }
    
    report.add_page(mock_page)
    
    assert_equal pass, true
  end  
  
  def test_add_blank_page_not_dispatch_the_page_create_event
    pass   = true
    report = init_report
    report.events.on(:page_create) {|e| pass = false }
    
    report.add_page(mock_blank_page)
    
    assert_equal pass, true
  end
  
  def test_add_blank_page_not_count_up_the_page_count_when_count_is_disabled
    report = init_report
    report.add_page(mock_not_counting_blank_page)
    report.add_page(mock_not_counting_blank_page)
    
    assert_equal report.page_count, 0
  end
  
  def test_finalize
    pass = false
    
    report = init_report
    report.events.on(:generate) {|e| pass = true }
    
    report.add_page(mock_page.should_receive(:finalize).once.mock)
    report.finalize
    
    assert_equal report.finalized?, true
    assert_equal pass, true
  end
  
  def test_finalize_never_work_when_report_is_already_finalized
    report = init_report
    report.finalize
    
    flexmock(report).should_receive(:finalize_current_page).times(0)
    report.finalize
  end
  
  def test_finalize_not_finalize_current_page_when_page_is_blank
    report = init_report
    report.add_page(mock_blank_page.should_receive(:finalize).times(0).mock)
    report.finalize
  end
  
  def test_load_layout_with_String
    report = init_report
    assert_equal report.load_layout('layout.tlf').flexmock_name, 'layout_base'
  end
  
  def test_load_layout_with_id
    report = init_report
    report.register_layout('layout.tlf', :id => :foo)
    
    assert_equal report.load_layout(:foo).flexmock_name, 'layout_base'
  end
  
  def test_load_layout_with_unknown_id
    report = init_report
    assert_nil report.load_layout(:unknown)
  end
  
  def test_load_layout_raise_when_invalid_value_set
    report = init_report
    assert_raises ArgumentError do
      report.load_layout(1)
    end
    assert_raises ArgumentError do
      report.load_layout(ThinReports::Layout.new('layout.tlf'))
    end
  end
  
  def test_load_layout_with_nil
    report = init_report
    report.register_layout('default.tlf', :default => true)
    
    assert_equal report.load_layout(nil).flexmock_name, 'layout_base'
  end
  
  def test_copy_page
    page = mock_page
    
    flexmock(page).
      should_receive(:finalize).with(:at => :copy).once.
      should_receive(:copy).and_return(mock_page('copied_page')).once
    
    report = init_report
    report.add_page(page)
    report.copy_page
    
    assert_equal report.page.flexmock_name, 'copied_page'
  end
    
  def init_report(options = {})
    Report::Internal.new(flexmock('report_base'), options)
  end
  
  def mock_page(page_name = 'page')
    flexmock(page_name).
      should_receive(:count? => true, :blank? => false).
      should_receive(:no=).with(::Numeric).once.mock
  end
  
  def mock_blank_page
    flexmock('blank_page').
      should_receive(:count? => true, :blank? => true).
      should_receive(:no=).with(::Numeric).once.mock
  end
  
  def mock_not_counting_blank_page
    flexmock('blank_page').
      should_receive(:count? => false, :blank? => true).
      should_receive(:no=).with(::Numeric).times(0).mock
  end
end
