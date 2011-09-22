# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::PDF::Document::TestPage < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def create_pdf
    @pdf = ThinReports::Generator::PDF::Document.new
  end
  
  def test_change_page_format_should_return_true_at_first_time
    create_pdf
    format = create_basic_layout_format('basic_layout1.tlf')
    
    assert_equal @pdf.send(:change_page_format?, format), true
  end
  
  def test_change_page_format_should_return_false_when_given_the_same_format
    create_pdf
    format = create_basic_layout_format('basic_layout1.tlf')
    
    @pdf.instance_variable_set(:@current_page_format, format)
    assert_equal @pdf.send(:change_page_format?, format), false
  end
  
  def test_change_page_format_should_return_true_when_given_the_other_format
    create_pdf
    format1 = create_basic_layout_format('basic_layout1.tlf')
    format2 = create_basic_layout_format('basic_layout2.tlf')
    
    @pdf.instance_variable_set(:@current_page_format, format1)
    assert_equal @pdf.send(:change_page_format?, format2), true
  end
  
  def test_new_basic_page_options
    format  = create_basic_layout_format('basic_layout1.tlf')
    options = create_pdf.send(:new_basic_page_options, format)
    
    assert_equal options[:layout], format.page_orientation.to_sym
    assert_equal options[:size], format.page_paper_type
  end
  
  def test_new_basic_page_options_when_the_layout_has_customize_size
    format = flexmock('format').
      should_receive(:user_paper_type? => true,
                     :page_width       => 100,
                     :page_height      => 100,
                     :page_orientation => 'portrait').mock
    
    options = create_pdf.send(:new_basic_page_options, format)
    assert_equal options[:size], [100, 100]
  end
  
  def test_start_new_page_should_create_stamp
    create_pdf
    format = create_basic_layout_format('basic_layout1.tlf')
    @pdf.start_new_page(format)
    
    assert_includes @pdf.send(:format_stamp_registry), format.identifier
  end
  
  def test_start_new_page_should_not_create_stamp
    create_pdf
    format = create_basic_layout_format('basic_layout1.tlf')
    @pdf.start_new_page(format)
    @pdf.start_new_page(format)
    
    assert_equal @pdf.send(:format_stamp_registry).size, 1
  end
  
  def test_start_new_page_should_stamp_constantly
    create_pdf
    format = create_basic_layout_format('basic_layout1.tlf')
    flexmock(@pdf).should_receive(:stamp).with(format.identifier.to_s).times(2)
    
    @pdf.start_new_page(format)
    @pdf.start_new_page(format)
  end
  
  def test_add_blank_page_should_create_an_A4_size_page_in_first_page
    create_pdf
    flexmock(@pdf.internal).should_receive(:start_new_page).with(:size => 'A4').once
    
    @pdf.add_blank_page
  end
  
  def test_add_blank_page_should_call_with_no_arguments_since_second_page
    create_pdf
    @pdf.start_new_page(create_basic_layout_format('basic_layout1.tlf'))
    flexmock(@pdf.internal).should_receive(:start_new_page).with(Hash.new).once
    
    @pdf.add_blank_page
  end
end