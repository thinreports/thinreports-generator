# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::Pdf::Document::TestPage < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  def create_pdf
    @pdf = ThinReports::Generator::Pdf::Document.new
  end
  
  def in_manage_templates(use_tmp_dir = false, &block)
    tmp = File.expand_path(File.join('test', 'unit', 'tmp'))
    Dir.mkdir(tmp) if use_tmp_dir
    ThinReports.config.generator.pdf.manage_templates = tmp
    block.call(tmp)
  ensure
    if use_tmp_dir && File.exists?(tmp)
      File.delete(*Dir[File.join(tmp, '*')])
      Dir.rmdir(tmp)
    end
    ThinReports.config.generator.pdf.manage_templates = false
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
  
  def test_prepare_new_page_with_stamp_should_create_stamp
    create_pdf
    format = create_basic_layout_format('basic_layout1.tlf')
    @pdf.send(:prepare_new_page_with_stamp, format)
    
    assert_includes @pdf.send(:format_stamp_registry), format.identifier
  end
  
  def test_prepare_new_page_with_stamp_should_not_create_stamp
    create_pdf
    format = create_basic_layout_format('basic_layout1.tlf')
    @pdf.send(:prepare_new_page_with_stamp, format)
    @pdf.send(:prepare_new_page_with_stamp, format)
    
    assert_equal @pdf.send(:format_stamp_registry).size, 1
  end
  
  def test_prepare_new_page_with_stamp_should_stamp
    create_pdf
    format = create_basic_layout_format('basic_layout1.tlf')
    flexmock(@pdf).should_receive(:stamp).with(format.identifier.to_s).times(2)
    
    @pdf.send(:prepare_new_page_with_stamp, format)
    @pdf.send(:prepare_new_page_with_stamp, format)
  end
  
  def test_format_template_file
    in_manage_templates do |dir|
      create_pdf
      format = create_basic_layout_format('basic_layout1.tlf')
      
      assert_equal @pdf.send(:format_template_file, format),
                   File.join(dir, "#{format.identifier}.pdf")
      assert_equal @pdf.instance_variable_get(:@format_templates_store), dir
    end
  end
  
  def test_create_format_template
    in_manage_templates(true) do |dir|
      create_pdf
      format = create_basic_layout_format('basic_layout1.tlf')
      @pdf.send(:create_format_template, format, File.join(dir, 'test.pdf'))
      
      assert_equal File.exists?(File.join(dir, 'test.pdf')), true
    end
  end
  
  def test_prepare_new_page_with_template_should_create_template_file_at_first_time
    in_manage_templates(true) do |dir|
      create_pdf
      format = create_basic_layout_format('basic_layout1.tlf')
      @pdf.send(:prepare_new_page_with_template, format)
      
      assert_equal File.exists?(File.join(dir, "#{format.identifier}.pdf")), true
    end
  end
  
  def test_prepare_new_page_with_template_should_not_create_template_and_update_atime_of_existing_template
    in_manage_templates(true) do |dir|
      create_pdf
      format   = create_basic_layout_format('basic_layout1.tlf')
      tmp_file = @pdf.send(:format_template_file, format)
      
      @pdf.send(:prepare_new_page_with_template, format)
      
      atime = File.atime(tmp_file)
      
      flexmock(@pdf).should_receive(:create_format_template).times(0)
      flexmock(File).should_receive(:utime).once
      
      @pdf.send(:prepare_new_page_with_template, format)
    end
  end
  
  def test_prepare_new_page_with_template_should_call_start_new_page_with_template_option
    in_manage_templates(true) do |dir|
      create_pdf
      format   = create_basic_layout_format('basic_layout1.tlf')
      tmp_file = @pdf.send(:format_template_file, format)
      
      flexmock(@pdf.internal).
        should_receive(:start_new_page).with(:template => tmp_file).once
      
      @pdf.send(:prepare_new_page_with_template, format)
    end
  end
  
  def test_start_new_page_should_call_prepare_new_page_with_template_method
    in_manage_templates do |dir|
      create_pdf
      format = flexmock('format')
      
      flexmock(@pdf).
        should_receive(:change_page_format? => true).
        should_receive(:prepare_new_page_with_template).once
      
      @pdf.start_new_page(format)
    end
  end
  
  def test_start_new_page_should_call_prepare_new_page_with_stamp_method
    create_pdf
    format = flexmock('format')
    
    flexmock(@pdf).
      should_receive(:change_page_format? => true).
      should_receive(:prepare_new_page_with_stamp).once
    
    @pdf.start_new_page(format)
  end
  
  def test_add_blank_page_should_create_an_A4_size_page_in_first_page
    create_pdf
    flexmock(@pdf.internal).should_receive(:start_new_page).with(:size => 'A4').once
    
    @pdf.add_blank_page
  end
end