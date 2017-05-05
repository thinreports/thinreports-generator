# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::TextBlock::Formatter::TestBasic < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Formatter = Thinreports::Core::Shape::TextBlock::Formatter::Basic

  def test_apply_simple_format
    format = stub(format_base: 'Hello {value}!')

    assert_equal Formatter.new(format).apply('Thinreports'),
                 'Hello Thinreports!'
  end

  def test_apply_multiple_format
    format = stub(format_base: 'Hello {value}! And good bye {value}.')

    assert_equal Formatter.new(format).apply('Thinreports'),
                 'Hello Thinreports! And good bye Thinreports.'
  end
end
