# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Base::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def create_internal(format_config = {}, &block)
    format = unless format_config.empty?
      format_klass = ::Class.new(ThinReports::Core::Shape::Basic::Format) {
        config_reader(*format_config.keys.map {|k| k.to_sym })
      }
      format_klass.new(format_config)
    else
      ThinReports::Core::Shape::Basic::Format.new({})
    end
    
    klass = ::Class.new(ThinReports::Core::Shape::Base::Internal, &block)
    klass.new(flexmock('parent'), format)
  end
  
  def test_self_format_delegators_should_defines_method_delegated_from_format
    internal = create_internal('m1' => 'm1_value') {
      format_delegators :m1
    }
    assert_respond_to internal, :m1
  end
  
  def test_method_delegated_from_format_should_return_same_value_as_an_format
    internal = create_internal('m1' => 'm1 value') {
      format_delegators :m1
    }
    assert_same internal.m1, internal.format.m1
  end
  
  def test_switch_parent_should_replace_a_parent_property_to_the_specified_new_parent
    new_parent = flexmock('new_parent')
    
    internal = create_internal
    internal.switch_parent!(new_parent)
    
    assert_same internal.parent, new_parent
  end
  
  def test_copied_internal_should_have_the_new_value_specified_as_a_parent_property
    new_parent = flexmock('new_parent')
    internal = create_internal {
      def style
        @style ||= ThinReports::Core::Shape::Style::Base.new(format)
      end
    }
    assert_same internal.copy(new_parent).parent, new_parent
  end
  
  def test_copied_internal_should_have_style_copied_from_original
    internal = create_internal {
      def style
        @style ||= ThinReports::Core::Shape::Style::Base.new(format)
      end
    }
    internal.style.write_internal_style(:foo, 'bar')
    new_internal = internal.copy(flexmock('new_parent'))
    
    assert_equal new_internal.style.read_internal_style(:foo), 'bar'
  end
  
  def test_copied_internal_should_have_states_property_copied_from_original
    internal = create_internal {
      def style
        @style ||= ThinReports::Core::Shape::Style::Base.new(format)
      end
    }
    internal.states[:foo] = 'bar'
    new_internal = internal.copy(flexmock('new_parent'))
    
    assert_equal new_internal.states[:foo], 'bar'
  end
  
  def test_copy_should_execute_block_with_new_internal_as_argument
    internal = create_internal {
      def style
        @style ||= ThinReports::Core::Shape::Style::Base.new(format)
      end
    }
    internal.copy(flexmock('new_parent')) do |new_internal|
      assert_equal new_internal.is_a?(ThinReports::Core::Shape::Base::Internal), true
    end
  end
end