# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestStore < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  List = ThinReports::Core::Shape::List
  
  def test_new
    klass = List::Store.new(:foo => 'foo', :hoge => 0)
    
    assert_instance_of ::Class, klass
    
    st1 = klass.new
    st2 = klass.new
    
    refute_same st1.foo, st2.foo
    # Fixnum is immutable
    assert_same st1.hoge, st2.hoge
  end
  
  def test_init
    store = List::Store.init(:foo => 0, :hoge => 'hoge')
    
    assert_respond_to store, :foo
    assert_respond_to store, :hoge
    
    assert_equal store.foo, 0
    assert_equal store.hoge, 'hoge'
  end
  
  def test_copy
    store = List::Store.init(:foo => Time.now)
    
    copied = store.copy
    
    assert_equal store.foo, copied.foo
    refute_same store.foo, copied.foo
  end
end