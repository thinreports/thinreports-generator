# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::TestShape < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  ShapeModule = ThinReports::Core::Shape
  
  def test_find_by_type
    assert_same ShapeModule.find_by_type('s-tblock'), ShapeModule::Tblock
    assert_same ShapeModule.find_by_type('s-list'), ShapeModule::List
    assert_same ShapeModule.find_by_type('s-text'), ShapeModule::Text

    assert_same ShapeModule.find_by_type('s-image'), ShapeModule::Basic
    assert_same ShapeModule.find_by_type('s-line'), ShapeModule::Basic
    assert_same ShapeModule.find_by_type('s-rect'), ShapeModule::Basic
    assert_same ShapeModule.find_by_type('s-ellipse'), ShapeModule::Basic
    
    assert_raises ThinReports::Errors::UnknownShapeType do
      ShapeModule.find_by_type('unknown')
    end
  end
  
  def test_Configuration
    assert_same ShapeModule::Configuration('s-list'),
                ShapeModule::List::Configuration

    # When shape don't have a Configuration
    assert_raises ThinReports::Errors::NoConfigurationFound do
      ShapeModule::Configuration('s-line')
    end
  end
end