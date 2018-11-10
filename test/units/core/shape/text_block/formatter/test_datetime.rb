# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::TextBlock::Formatter::TestDatetime < Minitest::Test
  include Thinreports::TestHelper

  # Aliases
  TextBlock = Thinreports::Core::Shape::TextBlock
  Formatter = TextBlock::Formatter::Datetime

  def setup
    @datetime_format = '%Y/%m/%d %H:%M:%S'
    @time = Time.now
  end

  def text_block_format(format = {})
    default = {'base' => '', 'datetime' => {'format' => '%Y/%m/%d %H:%M:%S'}}
    TextBlock::Format.new('format' => default.merge(format))
  end

  def test_apply_datetime_format_without_basic_format
    formatter = Formatter.new(text_block_format)

    assert_equal @time.strftime(@datetime_format),
                 formatter.apply(@time)
  end

  def test_apply_datetime_format_with_basic_format
    formatter = Formatter.new(text_block_format('base' => 'Now: {value}'))

    assert_equal "Now: #{@time.strftime(@datetime_format)}",
                 formatter.apply(@time)

  end

  def test_not_apply_datetime_format_and_return_raw_value
    # When value is invalid
    formatter = Formatter.new(text_block_format)

    assert_same formatter.apply(val = 'invalid value'), val
    assert_same formatter.apply(val = 123456), val

    # When format is empty
    formatter = Formatter.new(text_block_format('datetime' => {'format' => ''}))

    assert_same formatter.apply(@time), @time
  end
end
