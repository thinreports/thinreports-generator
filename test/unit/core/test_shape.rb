# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::TestShape < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  ShapeModule = Thinreports::Core::Shape

  def test_find_by_type_should_return_PageNumber
    assert_same ShapeModule.find_by_type('page-number'), ShapeModule::PageNumber
  end

  def test_find_by_type_should_return_ImageBlock
    assert_same ShapeModule.find_by_type('image-block'), ShapeModule::ImageBlock
  end

  def test_find_by_type_should_return_TextBlock
    assert_same ShapeModule.find_by_type('text-block'), ShapeModule::TextBlock
  end

  def test_find_by_type_should_return_List
    assert_same ShapeModule.find_by_type('list'), ShapeModule::List
  end

  def test_find_by_type_should_return_Text
    assert_same ShapeModule.find_by_type('text'), ShapeModule::Text
  end

  def test_find_by_type_should_return_Basic_as_Image
    assert_same ShapeModule.find_by_type('image'), ShapeModule::Basic
  end

  def test_find_by_type_should_return_Basic_as_Line
    assert_same ShapeModule.find_by_type('line'), ShapeModule::Basic
  end

  def test_find_by_type_should_return_Basic_as_Rect
    assert_same ShapeModule.find_by_type('rect'), ShapeModule::Basic
  end

  def test_find_by_type_should_return_Basic_as_Ellipse
    assert_same ShapeModule.find_by_type('ellipse'), ShapeModule::Basic
  end

  def test_find_by_type_should_raise
    assert_raises Thinreports::Errors::UnknownShapeType do
      ShapeModule.find_by_type('unknown')
    end
  end
end
