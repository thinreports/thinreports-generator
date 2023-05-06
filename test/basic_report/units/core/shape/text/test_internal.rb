# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::Core::Shape::Text::TestInternal < Minitest::Test
  include Thinreports::BasicReport::TestHelper

  Text = Thinreports::BasicReport::Core::Shape::Text

  def create_internal(format_config = {})
    report = Thinreports::BasicReport::Report.new layout: layout_file.path
    Text::Internal.new(report.start_new_page, Text::Format.new(format_config))
  end

  def test_type_of?
    assert create_internal.type_of?('text'), true
    refute create_internal.type_of?(:basic), false
  end

end
