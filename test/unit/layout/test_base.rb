# coding: utf-8

require 'test/unit/helper'

class ThinReports::Layout::TestBase < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Layout = ThinReports::Layout::Base
  
  def test_load_format_raise_error_when_file_not_found
    assert_raises ThinReports::Errors::LayoutFileNotFound do
      Layout.load_format('dummy.tlf')
    end
  end
  
  def test_load_format
    flexmock(File).should_receive(:exists? => true).once
    flexmock(ThinReports::Layout::Format).should_receive(:build).once
    
    Layout.load_format('sample.tlf')
  end
  
  def test_load_format_when_omit_the_file_extension
    specified_name = 'sample'
    resolved_name  = 'sample.tlf'
    
    flexmock(File).
      should_receive(:exists?).with(resolved_name).and_return(true).once
    flexmock(ThinReports::Layout::Format).should_receive(:build).once
    
    Layout.load_format(specified_name)
  end
  
  def test_Page_when_not_defined_PageHelpers
    assert_same Layout.Page, ThinReports::Core::Page
  end
  
  def test_Page_when_defined_PageHelpers
    Layout.send(:PageHelpers, &proc{})
    
    refute_same Layout.Page, ThinReports::Core::Page
    
    # Teardown
    ThinReports::Layout::Base.send(:remove_const, :Page)
  end
  
  def test_PageHelpers
    Layout.send(:PageHelpers) do
      def foo
        'foo'
      end
    end
    
    assert_same Layout::Page.superclass, ThinReports::Core::Page
    assert Layout::Page.method_defined?(:foo)
    
    # Teardown
    ThinReports::Layout::Base.send(:remove_const, :Page)
  end
  
  def test_initialize_with_specified_id
    layout = init_layout(:id => :foo)
    assert_equal layout.id, :foo
  end
  
  def test_default?
    assert_equal init_layout.default?, true
    assert_equal init_layout(:id => :foo).default?, false
  end
  
  def test_config
    layout = init_layout
    assert_instance_of ThinReports::Layout::Configuration, layout.config
  end
  
  def test_init_new_page
    parent = flexmock('parent')
    layout = init_layout
    
    # Should call ThinReports::Core::Page#new with parent and layout.
    flexmock(ThinReports::Core::Page).
      should_receive(:new).with(parent, layout).once
    
    layout.init_new_page(parent)
  end
  
  def init_layout(options = {})
    flexmock(Layout).should_receive(:load_format => flexmock('format'))
    Layout.new('dummy.tlf', options)
  end
end