# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Text::TestInternal < Minitest::Test
  include Thinreports::TestHelper

  Text = Thinreports::Core::Shape::Text

  def create_internal(format_config = {})
    report = Thinreports::Report.new layout: layout_file.path
    Text::Internal.new(report.start_new_page, Text::Format.new(format_config))
  end

  def test_type_of?
    assert create_internal.type_of?('text'), true
    refute create_internal.type_of?(:basic), false
  end

end
