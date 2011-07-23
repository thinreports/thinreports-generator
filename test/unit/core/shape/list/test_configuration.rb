# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestConfiguration < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  List = ThinReports::Core::Shape::List
  
  def setup
    @events = flexmock('events')
    @store  = flexmock('store')
    @config = List::Configuration.new
  end  
  
  def test_use_stores
    flexmock(List::Store).should_receive(:init).with(::Hash).once
    
    @config.use_stores(:a => 0, :b => 0)
  end
  
  def test_store
    flexmock(List::Store).should_receive(:init => @store)
    
    @config.use_stores(:a => 0, :b => 0)
    assert_same @config.store, @store
  end
  
  def test_store_return_nil_when_uninitialized_yet
    assert_nil @config.store
  end
  
  def test_copy
    copied_store = flexmock('copied store')
    
    flexmock(@store, :copy => copied_store)
    flexmock(List::Store).should_receive(:init => @store)

    copied_events = flexmock('copied events')
    
    flexmock(@events, :copy => copied_events)
    flexmock(List::Events).should_receive(:new => @events)
    
    @config = List::Configuration.new
    @config.use_stores(:a => 1)
    
    copied_config = @config.copy
    
    assert_same copied_config.events, copied_events
    assert_same copied_config.store, copied_store
  end
end