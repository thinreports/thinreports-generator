# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::PDF::Graphics::TestText < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def create_pdf
    pdf = ThinReports::Generator::PDF::Document.new
    pdf.internal.start_new_page
    pdf
  end
  
  def test_text_line_leading
    pdf = create_pdf
    
    font = {:name => 'IPAMincho', :size => 36}
    font_height = pdf.internal.font(font[:name], :size => font[:size]).height
    
    assert_equal pdf.send(:text_line_leading, 100, font), 100 - font_height
  end
  
  def test_text_without_line_wrap
    pdf = create_pdf
    assert_equal pdf.send(:text_without_line_wrap, ' ' * 2), Prawn::Text::NBSP * 2
  end
  
  def test_text_box_should_not_raise_Error_of_PrawnCannotFit
    pdf = create_pdf
    pdf.text_box('foo', 0, 0, 1, 1, :font => 'IPAMincho',
                                    :size => 100,
                                    :color => '000000')
    pass
  end
end