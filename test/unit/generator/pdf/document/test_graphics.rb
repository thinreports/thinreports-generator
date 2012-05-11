# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::PDF::TestGraphics < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  class TestGraphics
    attr_accessor :pdf
    include ThinReports::Generator::PDF::Graphics
  end
  
  def setup
    @g     = TestGraphics.new
    @g.pdf = flexmock('pdf')
  end
  
  def test_setup_custom_graphic_states
    @g.pdf.
      should_receive(:line_width).
      with(TestGraphics::BASE_LINE_WIDTH).once
    
    @g.send(:setup_custom_graphic_states)
  end
  
  def test_line_width
    @g.pdf.
      should_receive(:line_width).
      with(10 * TestGraphics::BASE_LINE_WIDTH).once
    
    @g.send(:line_width, 10)
  end
  
  def test_save_graphics_state
    @g.pdf.should_receive(:save_graphics_state).once
    @g.send(:save_graphics_state)
  end
  
  def test_restore_graphics_state
    @g.pdf.should_receive(:restore_graphics_state).once
    @g.send(:restore_graphics_state)
  end
end
