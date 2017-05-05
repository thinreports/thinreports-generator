# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Manager::TestFormat < Minitest::Test
  include Thinreports::TestHelper

  class TestFormat < Thinreports::Core::Shape::Manager::Format; end

  def test_identifier_should_return_the_same_as_object_id_when_id_is_not_given
    format = TestFormat.new({})
    assert_equal format.identifier, format.object_id
  end

  def test_identifier_should_return_the_specified_id_when_id_is_given
    assert_equal TestFormat.new({}, :any_id).identifier, :any_id
  end

  def test_has_shape
    format = TestFormat.new({}) do |f|
      f.shapes[:foo] = 1
    end
    assert format.has_shape?(:foo)
    refute format.has_shape?(:unknown)
  end

  def test_find_shape_should_return_format_of_shape_when_shape_is_found
    format = TestFormat.new({}) do |f|
      f.shapes[:foo] = Thinreports::Core::Shape::TextBlock::Format.new('id' => 'foo',
                                                                       'type' => 'text-block')
    end
    assert_equal format.find_shape(:foo).id, 'foo'
  end

  def test_find_shape_should_return_nil_when_shape_is_not_found
    assert_nil TestFormat.new({}).find_shape(:unknown)
  end
end
