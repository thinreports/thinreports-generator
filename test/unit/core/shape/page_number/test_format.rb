# coding: utf-8

require 'test_helper'

class Thinreports::Core::Shape::PageNumber::TestFormat < Minitest::Test
  include Thinreports::TestHelper

  PAGE_NUMBER_FORMAT = {
    'id' => '',
    'type' => 'page-number',
    'display' => true,
    'x' => 100.0,
    'y' => 200.0,
    'width' => 300.0,
    'height' => 400.0,
    'format' => '{page} / {total}',
    'target' => 'report',
    'style' => {
      'overflow' => 'truncate',
      'letter-spacing' => 'normal',
      'color' => '#000000',
      'font-size' => 18,
      'font-family' => ['Helvetica'],
      'line-height' => 60,
      'line-height-ratio' => 1.5,
      'text-align' => 'left'
    }
  }

  PageNumber = Thinreports::Core::Shape::PageNumber

  def test_attribute_readers
    format = PageNumber::Format.new(PAGE_NUMBER_FORMAT)

    assert_equal 'truncate', format.overflow
    assert_equal 'report', format.target
    assert_equal '{page} / {total}', format.default_format
    assert_equal({ 'x' => 100.0, 'y' => 200.0, 'width' => 300.0, 'height' => 400.0 }, format.box)
  end

  def test_id
    format = PageNumber::Format.new(PAGE_NUMBER_FORMAT)
    assert_equal '__pageno1', format.id

    format = PageNumber::Format.new(PAGE_NUMBER_FORMAT.merge('id' => 'foo'))
    assert_equal 'foo', format.id
  end
end
