# frozen_string_literal: true

require 'test_helper'

class Thinreports::Generator::PDF::TestGraphics < Minitest::Test
  include Thinreports::TestHelper

  class TestGraphics
    attr_accessor :pdf
    include Thinreports::Generator::PDF::Graphics
  end

  def setup
    @g = TestGraphics.new
    @g.pdf = mock('pdf')
  end

  def test_setup_custom_graphic_states
    @g.pdf.expects(:line_width).
      with(TestGraphics::BASE_LINE_WIDTH).once

    @g.send(:setup_custom_graphic_states)
  end

  def test_line_width
    @g.pdf.
      expects(:line_width).
      with(10 * TestGraphics::BASE_LINE_WIDTH).once

    @g.send(:line_width, 10)
  end

  def test_save_graphics_state
    @g.pdf.expects(:save_graphics_state).once
    @g.send(:save_graphics_state)
  end

  def test_restore_graphics_state
    @g.pdf.expects(:restore_graphics_state).once
    @g.send(:restore_graphics_state)
  end
end
