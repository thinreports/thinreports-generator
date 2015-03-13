# coding: utf-8

require 'test_helper'

class ThinReports::Core::Shape::TextBlock::TestFormatter < Minitest::Test
  include ThinReports::TestHelper

  # Alias
  Formatter = ThinReports::Core::Shape::TextBlock::Formatter

  def test_initialize_formatter_by_type
    assert_instance_of Formatter::Basic,
      Formatter.setup( stub(format_type: '') )

    assert_instance_of Formatter::Number,
      Formatter.setup( stub(format_type: 'number') )

    assert_instance_of Formatter::Datetime,
      Formatter.setup( stub(format_type: 'datetime') )

    assert_instance_of Formatter::Padding,
      Formatter.setup( stub(format_type: 'padding') )

    assert_raises ThinReports::Errors::UnknownFormatterType do
      Formatter.setup( stub(format_type: 'unknown') )
    end
  end
end
