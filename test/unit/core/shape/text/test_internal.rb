# coding: utf-8

require 'test_helper'

class Thinreports::Core::Shape::Text::TestInternal < Minitest::Test
  include Thinreports::TestHelper
  
  Text = Thinreports::Core::Shape::Text
  
  def create_internal(format_config = {})
    report = new_report('layout_text1.tlf')
    Text::Internal.new(report.start_new_page, Text::Format.new(format_config))
  end
  
  def test_type_of?
    assert create_internal.type_of?(:text), true
    refute create_internal.type_of?(:basic), false
  end

  def test_inline_format_enabled?
    assert create_internal('inline-format' => 'true').inline_format_enabled?
    refute create_internal('inline-format' => 'false').inline_format_enabled?
    refute create_internal.inline_format_enabled?
  end
end
