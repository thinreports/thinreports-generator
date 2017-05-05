# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::TextBlock::TestInterface < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  TextBlock = Thinreports::Core::Shape::TextBlock

  def create_interface(format_config = {})
    report = Thinreports::Report.new layout: layout_file.path
    parent = report.start_new_page

    TextBlock::Interface.new parent, TextBlock::Format.new(format_config)
  end

  def test_format_enabled_asker_should_operate_as_delegator_of_internal
    tblock = create_interface('format' => {'type' => 'datetime'})
    assert_equal tblock.format_enabled?, tblock.internal.format_enabled?
  end

  def test_format_enabled_should_properly_set_value_to_internal
    tblock = create_interface('format' => {'type' => 'number'})
    tblock.format_enabled(false)

    assert_equal tblock.internal.format_enabled?, false
  end

  def test_set_should_properly_set_a_value
    tblock = create_interface
    tblock.set(1000, visible: false)

    assert_equal tblock.value, 1000
  end

  def test_set_should_properly_set_styles
    tblock = create_interface
    tblock.set(1000, color: '#ff0000',
                     bold: true,
                     italic: true)

    assert_equal [tblock.style(:color),
                  tblock.style(:bold),
                  tblock.style(:italic)],
                 ['#ff0000', true, true]
  end

  def test_value=
    report = Thinreports::Report.new layout: layout_file.path
    page = report.start_new_page

    page.item(:text_block).value = 'foo'
    assert_equal 'foo', page.item(:text_block).value

    page.item(:text_block).value += 'bar'
    assert_equal 'foobar', page.item(:text_block).value

    page.item(:text_block).value = 1000
    page.item(:text_block).value += 999
    assert_equal 1999, page.item(:text_block).value
  end
end
