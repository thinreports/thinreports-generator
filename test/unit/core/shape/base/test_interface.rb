# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Base::TestInterface < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  class TestInterface < ThinReports::Core::Shape::Base::Interface
    internal_delegators :m1, :m2
    
    # For testing
    # Instead, #internal method is overwritten by flexmock.
    def init_internal(parent, format)
      # Nothing to do
    end
  end
  
  def setup
    internal   = flexmock(:m1 => 'm1', :m2 => 'm2')
    @interface = TestInterface.new(flexmock('parent'), flexmock('format'))
    
    flexmock(@interface, :internal => internal)
  end
  
  def test_internal_delegators_macro
    assert_respond_to @interface, :m1
    assert_respond_to @interface, :m2
  end
  
  def test_methods_delegated_from_internal
    assert_same @interface.m1, @interface.internal.m1
    assert_same @interface.m2, @interface.internal.m2
  end
  
  def test_forced_to_specify_an_internal_argument
    internal  = flexmock('forced_internal')
    interface = TestInterface.new(flexmock('parent'), flexmock('format'), 
                                  internal)
    
    assert_same internal, interface.internal
  end
  
  def test_copy
    flexmock(@interface.internal, :copy   => flexmock('new_internal'),
                                  :format => flexmock('format'))
    
    new_interface = @interface.copy(flexmock('new_parent'))
    
    refute_same new_interface, @interface
    assert_instance_of TestInterface, new_interface
  end
end