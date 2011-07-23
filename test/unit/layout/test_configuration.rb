# coding: utf-8

require 'test/unit/helper'

class ThinReports::Layout::TestConfiguration < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Configuration = ThinReports::Layout::Configuration
  
  def setup
    layout = flexmock('layout')
    flexmock(layout).should_receive(:format => flexmock('layout_format'))
    
    @config = Configuration.new(layout)
  end
  
  def test_undef_items_method
    refute_respond_to @config, :items
  end
  
  def test_undef_values_method
    refute_respond_to @config, :values
  end
  
  def test_properly_set_init_item_handler
    list_format = flexmock('list_format').should_receive(:type => 's-list').once.mock
    list_config = flexmock('list_config').should_receive(:new).once.mock
    
    flexmock(ThinReports::Core::Shape).
      should_receive(:Configuration).with('s-list').and_return(list_config).once
      
    @config.manager.init_item(list_format)
  end
  
  def test_activate
    list_config = flexmock('list_config').should_receive(:copy).once.mock
    @config.manager.shapes[:foo] = list_config

    @config.activate(:foo)
  end
  
  def test_activate_return_nil_when_unknown_shape_id
    assert_nil @config.activate(:unknown)
  end
end