# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Manager::TestFormat < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  class TestFormat < ThinReports::Core::Shape::Manager::Format
  end
  
  def test_identifier_equal_the_object_id
    format = TestFormat.new({})
    assert_equal format.identifier, format.object_id
  end
  
  def test_identifier_equal_the_given_id
    format = TestFormat.new({}, :any_id)
    assert_equal format.identifier, :any_id
  end
  
  def test_shapes
    format = TestFormat.new({})
    assert_instance_of ThinReports::Core::OrderedHash, format.shapes
  end
  
  def test_find_shape
    format = TestFormat.new({}) do |f|
      f.shapes[:foo] = 'foo'
      f.shapes[:boo] = 'boo'
    end
    
    assert_equal format.find_shape(:foo), 'foo'
    assert_equal format.find_shape(:boo), 'boo'
  end
  
  def test_find_shape_return_nil_when_id_is_not_found
    format = TestFormat.new({})
    assert_nil format.find_shape(:unknown)
  end
end