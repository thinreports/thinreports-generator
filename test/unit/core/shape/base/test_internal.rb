# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Base::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  class TestInternal < ThinReports::Core::Shape::Base::Internal
    format_delegators :m1, :m2
  end
  
  def setup
    @internal = TestInternal.new(flexmock('parent'),
                                 flexmock(:m1 => 'm1', :m2 => 'm2'))
  end
  
  def test_format_delegators_macro
    assert_respond_to @internal, :m1
    assert_respond_to @internal, :m2
  end
  
  def test_methods_delegated_from_format
    assert_same @internal.m1, @internal.format.m1
    assert_same @internal.m2, @internal.format.m2
  end
  
  def test_switch_parent!
    new_parent = flexmock('new_parent')
    res = @internal.switch_parent!(new_parent)
    
    assert_same @internal, res
    assert_same @internal.parent, new_parent
  end
  
  def test_available_style?
    assert_operator @internal, :available_style?, :fill
    assert_operator @internal, :available_style?, :stroke
    
    refute_operator @internal, :available_style?, 'font-family'
    refute_operator @internal, :available_style?, :x
  end
  
  def test_attributes
    format = flexmock('format')
    format.should_receive(:svg_attrs).
      and_return('fill' => 'red',
                 'stroke' => 'black',
                 'x' => 100,
                 'y' => 100,
                 'width' => 200)
    internal = TestInternal.new(flexmock('parent'), format)
    internal.attrs['fill'] = '#ff0000'
    internal.attrs['stroke'] = '#000000'
    
    assert_equal internal.attributes, {'fill' => '#ff0000',
                                       'stroke' => '#000000',
                                       'x' => 100,
                                       'y' => 100,
                                       'width' => 200}
  end
  
  def test_copy
    @internal.attrs.update('stroke' => 'red')
    @internal.states.update(:value => '123')
    
    new_internal = @internal.copy(flexmock('new_parent'))
    
    refute_same @internal, new_internal
    assert_instance_of TestInternal, new_internal
    
    # Test for parent property
    refute_same @internal.parent, new_internal.parent
    
    # Test for format property
    assert_same @internal.format, new_internal.format
    
    # Test for attrs
    args_attrs_test = [@internal.attrs, new_internal.attrs]
    
    assert_equal(*args_attrs_test)
    refute_same(*args_attrs_test)
    
    # Test for value of attrs
    args_attr_values_test = [@internal.attrs['stroke'],
                            new_internal.attrs['stroke']]
    
    assert_equal(*args_attr_values_test)
    refute_same(*args_attr_values_test)
    
    @internal.attrs['fill'] = 'black'
    assert_nil new_internal.attrs['fill']
    
    # Test for states
    args_states_test = [@internal.states, new_internal.states]
    
    assert_equal(*args_states_test)
    refute_same(*args_states_test)
    
    # Test for value of states
    args_state_values_test = [@internal.states[:value],
                              new_internal.states[:value]]
    
    assert_equal(*args_state_values_test)
    refute_same(*args_state_values_test)

    @internal.states[:value].reverse!
    refute_equal(*args_state_values_test)
  end
end