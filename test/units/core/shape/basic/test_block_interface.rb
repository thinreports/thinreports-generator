# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Basic::TestBlockInterface < Minitest::Test
  include Thinreports::TestHelper

  Basic = Thinreports::Core::Shape::Basic

  def setup
    report = Thinreports::Report.new layout: layout_file.path
    parent = report.start_new_page

    format = Basic::BlockFormat.new({})
    internal = Basic::BlockInternal.new parent, format

    @interface = Basic::BlockInterface.new parent, format, internal
  end

  def test_value_should_work_as_reader_with_no_arguments
    @interface.internal.write_value('new value')
    assert_equal @interface.value, 'new value'
  end

  def test_value_should_work_as_writer_with_arguments
    @interface.value('new value')
    assert_equal @interface.internal.read_value, 'new value'
  end
end
