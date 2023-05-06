# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::Core::Shape::TextBlock::TestFormatter < Minitest::Test
  include Thinreports::BasicReport::TestHelper

  # Alias
  Formatter = Thinreports::BasicReport::Core::Shape::TextBlock::Formatter

  def test_initialize_formatter_by_type
    assert_instance_of Formatter::Basic,
      Formatter.setup( stub(format_type: '') )

    assert_instance_of Formatter::Number,
      Formatter.setup( stub(format_type: 'number') )

    assert_instance_of Formatter::Datetime,
      Formatter.setup( stub(format_type: 'datetime') )

    assert_instance_of Formatter::Padding,
      Formatter.setup( stub(format_type: 'padding') )

    assert_raises Thinreports::BasicReport::Errors::UnknownFormatterType do
      Formatter.setup( stub(format_type: 'unknown') )
    end
  end
end
