# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::TextBlock::TestFormat < Minitest::Test
  include Thinreports::TestHelper

  TEXT_BLOCK_FORMAT = {
    'id' => 'text_block',
    'reference-id' => 'referenced_text_block',
    'type' => 'text-block',
    'display' => true,
    'multiple-line' => false,
    'x' => 100.0,
    'y' => 200.0,
    'width' => 300.0,
    'height' => 400.0,
    'value' => 'default value',
    'format' => {
      'base' => 'Price: {value}',
      'type' => 'number',
      'number' => {
        'delimiter' => ',',
        'precision' => 1
      }
    },
    'description' => 'Description for item',
    'style' => {
      'word-wrap' => 'break-word',
      'overflow' => 'truncate',
      'text-align' => 'right',
      'vertical-align' => 'middle',
      'color' => '#000000',
      'font-size' => 12,
      'font-family' => ['Helvetica'],
      'font-style' => ['bold', 'italic', 'linethrough', 'underline'],
      'letter-spacing' => 'normal',
      'line-height' => 30,
      'line-height-ratio' => 1.5
    }
  }

  TextBlock = Thinreports::Core::Shape::TextBlock

  def test_attribute_readers
    format = TextBlock::Format.new(TEXT_BLOCK_FORMAT)

    assert_equal 'referenced_text_block', format.ref_id
    assert_equal 'middle', format.valign
    assert_equal 'truncate', format.overflow
    assert_equal 30, format.line_height
    assert_equal false, format.multiple?
    assert_equal 'Price: {value}', format.format_base
    assert_equal 'number', format.format_type
  end

  def test_has_reference?
    format_has_reference = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge('reference-id' => 'other'))
    assert_equal true, format_has_reference.has_reference?

    format_has_no_reference = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge('reference-id' => ''))
    assert_equal false, format_has_no_reference.has_reference?
  end

  def test_has_format?
    format_has_text_format = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge(
      'format' => { 'type' => 'datetime' }
    ))
    assert_equal true, format_has_text_format.has_format?

    format_has_no_text_format = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge(
      'format' => { 'type' => '' }
    ))
    assert_equal false, format_has_no_text_format.has_format?
  end

  def test_number_format_attribute_readers
    format = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge(
      'format' => {
        'type' => 'number',
        'number' => {
          'delimiter' => ',',
          'precision' => 1
        }
      }
    ))
    assert_equal ',', format.format_number_delimiter
    assert_equal 1, format.format_number_precision
  end

  def test_datetime_format_attribute_readers
    format = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge(
      'format' => {
        'type' => 'datetime',
        'datetime' => {
          'format' => '%Y-%m-%d'
        }
      }
    ))
    assert_equal '%Y-%m-%d', format.format_datetime_format
  end

  def test_padding_format_attribute_readers
    format = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge(
      'format' => {
        'type' => 'padding',
        'padding' => {
          'char' => '0',
          'length' => 10,
          'direction' => 'L'
        }
      }
    ))
    assert_equal '0', format.format_padding_char
    assert_equal 'L', format.format_padding_dir
  end

  def test_format_padding_length
    format = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge(
      'format' => {
        'type' => 'padding',
        'padding' => {
          'char' => '0',
          'length' => 10,
          'direction' => 'L'
        }
      }
    ))
    assert_equal 10, format.format_padding_length

    format = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge(
      'format' => {
        'type' => 'padding',
        'padding' => {
          'char' => '0',
          'length' => '',
          'direction' => 'L'
        }
      }
    ))
    assert_equal 0, format.format_padding_length
  end

  def test_format_padding_rdir?
    format_direction_left = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge(
      'format' => {
        'type' => 'padding',
        'padding' => {
          'char' => '0',
          'length' => 10,
          'direction' => 'L'
        }
      }
    ))
    assert_equal false, format_direction_left.format_padding_rdir?

    format_direction_right = TextBlock::Format.new(TEXT_BLOCK_FORMAT.merge(
      'format' => {
        'type' => 'padding',
        'padding' => {
          'char' => '0',
          'length' => 10,
          'direction' => 'R'
        }
      }
    ))
    assert_equal true, format_direction_right.format_padding_rdir?
  end
end
