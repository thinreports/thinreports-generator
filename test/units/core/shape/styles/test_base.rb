# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Style::TestBase < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Style = Thinreports::Core::Shape::Style::Base

  def create_basic_format(base_style = {})
    Thinreports::Core::Shape::Basic::Format.new('style' => base_style)
  end

  def create_style(base_style = {})
    Style.new(create_basic_format(base_style))
  end

  def create_new_style(base_style = {}, &block)
    klass = ::Class.new(Style, &block)
    klass.new(create_basic_format(base_style))
  end

  def test_self_style_reader_should_properly_define_a_reading_method
    style = create_new_style {
      style_reader :hoge, 'foo'
    }
    assert_respond_to style, :hoge
  end

  def test_self_style_writer_should_properly_define_a_writing_method
    style = create_new_style {
      style_writer :hoge, 'foo'
    }
    assert_respond_to style, :hoge=
  end

  def test_self_style_accessor_should_properly_defines_reading_and_writing_methods
    style = create_new_style {
      style_accessor :hoge, 'foo'
    }
    assert_respond_to style, :hoge
    assert_respond_to style, :hoge=
  end

  def test_self_style_accessible_should_add_specified_styles_to_the_accessible_styles_variable
    style = create_new_style {
      style_accessible :hoge
      style_accessible :foo, :bar
    }
    assert_equal style.class.accessible_styles, [:hoge, :foo, :bar]
  end

  def test_self_accessible_styles_variable_should_not_be_shared_each_SubClasses
    style1 = create_new_style {
      style_accessible :hoge, :foo
    }
    assert_equal style1.class.accessible_styles, [:hoge, :foo]
  end

  def test_self_accessible_styles_variable_should_be_inherited_to_SubClass
    super_klass = ::Class.new(Style) {
      style_accessible :hoge, :foo
    }
    sub_klass = ::Class.new(super_klass)

    assert_equal sub_klass.accessible_styles, super_klass.accessible_styles
  end

  def test_self_accessible_styles_variables_of_SubClass_should_not_interfere_mutually
    super_klass = ::Class.new(Style) {
      style_accessible :foo, :bar
    }
    sub_klass1 = ::Class.new(super_klass)
    sub_klass2 = ::Class.new(super_klass)

    refute_same sub_klass1.accessible_styles, sub_klass2.accessible_styles
  end

  def test_read_internal_style_should_return_style_of_styles_when_style_is_found_in_styles
    style = create_style('hoge' => 'base_style')
    style.write_internal_style('hoge', 'new_style')

    assert_equal style.read_internal_style('hoge'), 'new_style'
  end

  def test_read_internal_style_should_return_style_of_base_when_style_is_not_found_in_styles
    style = create_style('hoge' => 'base_style')
    assert_equal style.read_internal_style('hoge'), 'base_style'
  end

  def test_write_internal_style_should_properly_set_style_to_the_styles
    style = create_style({})
    style.write_internal_style('hoge', 'hoge_style')

    assert_equal style.styles['hoge'], 'hoge_style'
  end

  def test_has_style_asker_should_return_true_when_specified_style_method_is_accessible
    style = create_new_style {
      style_accessible :hoge, :foo
    }
    assert_equal style.has_style?(:foo), true
  end

  def test_has_style_asker_should_return_false_when_specified_style_method_is_not_accessible
    style = create_new_style {
      style_accessible :foo
    }
    assert_equal style.has_style?(:hoge), false
  end

  def test_verify_style_value_should_raise_when_value_is_not_included_in_list
    assert_raises ArgumentError do
      create_style.send(:verify_style_value, :invalid, [:hoge, :foo, :bar])
    end
  end

  def test_verify_style_value_should_not_raise_when_value_is_found_in_list
    create_style.send(:verify_style_value, :valid, [:hoge, :valid, :foo])
  rescue ArgumentError
    flunk
  end

  def test_reader_method_caller_should_properly_delegate_to_real_method
    style = create_new_style('hoge_style' => 'hoge_style_value') {
      style_accessible :hoge
      style_reader :hoge, 'hoge_style'
    }
    assert_equal style[:hoge], 'hoge_style_value'
  end

  def test_writer_method_caller_should_properly_delegate_to_real_method
    style = create_new_style {
      style_accessible :hoge
      style_accessor :hoge, 'hoge_style'
    }
    style[:hoge] = 'hoge_style_value'
    assert_equal style.hoge, 'hoge_style_value'
  end

  def test_reader_method_caller_should_raise_when_style_is_not_accessible
    assert_raises Thinreports::Errors::UnknownShapeStyleName do
      create_new_style[:unknown]
    end
  end

  def test_writer_method_caller_should_raise_when_style_is_not_accessible
    assert_raises Thinreports::Errors::UnknownShapeStyleName do
      create_new_style[:unknown] = 'value'
    end
  end

  def test_copy_should_return_the_instance_of_the_same_class_as_itself
    style = create_style
    assert_instance_of Style, style.copy
  end

  def test_styles_of_copied_style_should_not_same_the_styles_of_original
    style = create_style
    refute_same style.styles, style.copy.styles
  end

  def test_styles_of_copied_style_should_equal_the_style_of_original
    style = create_style
    style.write_internal_style('foo', 'foo_value')
    assert_equal style.styles['foo'], style.copy.styles['foo']
  end

  def test_identifier_should_return_empty_string_when_the_style_is_not_set
    style = create_style
    assert_equal style.identifier, ''
  end

  def test_identifier_should_return_the_same_as_hash_value_of_styles_when_style_is_set_something
    style = create_style
    style.write_internal_style('foo', 'foo_value')

    assert_equal style.identifier, style.styles.hash.to_s
  end

  def test_finalized_styles
    base_styles = { 'foo' => 'default foo', 'bar' => 'default bar' }

    style = create_style(base_styles)
    style.write_internal_style('foo', 'new foo')

    assert_equal({ 'foo' => 'new foo', 'bar' => 'default bar' }, style.finalized_styles)
    assert_same style.finalized_styles, style.finalized_styles
  end
end
