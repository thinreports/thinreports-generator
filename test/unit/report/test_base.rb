# coding: utf-8

require 'test/unit/helper'

class ThinReports::Report::TestBase < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Report = ThinReports::Report
  
  def setup
    @report = Report::Base.new
  end
  
  def test_initialize_should_register_layout_as_default_when_layout_is_specified_as_the_option
    report = Report::Base.new :layout => data_file('basic_layout1.tlf')
    assert_equal report.default_layout.filename, data_file('basic_layout1.tlf')
  end
  
  def test_initialize_should_initialize_new_Report_without_default_layout
    assert_nil @report.default_layout
  end
  
  def test_use_layout_should_register_default_layout_when_default_property_is_omitted
    @report.use_layout(data_file('basic_layout1.tlf'))
    
    assert_equal @report.default_layout.filename, data_file('basic_layout1.tlf')
  end
  
  def test_use_layout_should_register_default_layout_when_default_property_is_true
    @report.use_layout(data_file('basic_layout2.tlf'), :default => true)
    
    assert_equal @report.default_layout.filename, data_file('basic_layout2.tlf')
  end
  
  def test_start_new_page_should_properly_create_a_new_Page_and_return
    @report.use_layout(data_file('basic_layout1'))
    
    assert_instance_of ThinReports::Core::Page, @report.start_new_page
  end
  
  def test_start_new_page_should_raise_when_the_layout_has_not_been_registered_yet
    assert_raises ThinReports::Errors::NoRegisteredLayoutFound do
      @report.start_new_page(:layout => :unknown)
    end
  end
  
  def test_start_new_page_should_create_a_new_page_using_a_default_layout
    @report.use_layout(data_file('basic_layout1.tlf'), :default => true)
    
    assert_equal @report.start_new_page.layout.filename, data_file('basic_layout1.tlf')
  end
  
  def test_start_new_page_should_create_a_new_page_using_a_layout_with_specified_id
    @report.use_layout(data_file('basic_layout1.tlf'), :id => :foo)
    
    assert_equal @report.start_new_page(:layout => :foo).layout.filename,
                 data_file('basic_layout1.tlf')
  end
  
  def test_start_new_page_should_create_a_new_page_using_a_specified_layoutfile
    new_page = @report.start_new_page(:layout => data_file('basic_layout1.tlf'))
    assert_equal new_page.layout.filename, data_file('basic_layout1.tlf')
  end
  
  def test_add_blank_page_should_properly_create_a_new_blank_page
    @report.use_layout(data_file('basic_layout1'))
    
    assert_instance_of ThinReports::Core::BlankPage, @report.add_blank_page
  end
  
  def test_layout_should_return_the_default_layout_with_no_arguments
    @report.use_layout(data_file('basic_layout1.tlf'), :default => true)
    
    assert_equal @report.layout.filename, data_file('basic_layout1.tlf')
  end
  
  def test_layout_should_raise_when_the_specified_layout_is_not_found
    assert_raises ThinReports::Errors::UnknownLayoutId do
      @report.layout(:unknown_layout_id)
    end
  end
  
  def test_layout_should_return_the_layout_with_specified_id
    @report.use_layout(data_file('basic_layout2.tlf'), :id => :foo)
    
    assert_equal @report.layout(:foo).filename, data_file('basic_layout2.tlf')
  end
  
  def test_generate_should_properly_initialize_Generator_and_call_generate_method_when_type_is_specified
    flexmock(ThinReports::Generator).
      should_receive(:new).
      with(:pdf, @report, {:option => :value}).
      and_return(flexmock(:generate => 'Success')).once
    
    assert_equal @report.generate(:pdf, :option => :value), 'Success'
  end
  
  def test_generate_should_properly_initialize_Generator_and_call_generate_method_when_type_is_omitted
    flexmock(ThinReports::Generator).
      should_receive(:new).
      with(:pdf, @report, {:option => :value}).
      and_return(flexmock(:generate => 'Success')).once
    
    assert_equal @report.generate(:option => :value), 'Success'
  end
  
  def test_generate_file_should_properly_initialize_Generator_and_call_generate_file_method_when_type_is_specified
    generator = flexmock('generator')
    generator.should_receive(:generate_file).with('output.pdf').once
    
    flexmock(ThinReports::Generator).
      should_receive(:new).
      with(:pdf, @report, {}).
      and_return(generator).once
    
    @report.generate_file(:pdf, 'output.pdf')
  end
  
  def test_generate_file_should_properly_initialize_Generator_and_call_generate_file_method_when_type_is_omitted
    generator = flexmock('generator')
    generator.should_receive(:generate_file).with('output.pdf').once
    
    flexmock(ThinReports::Generator).
      should_receive(:new).
      with(:pdf, @report, {:option => :value}).
      and_return(generator).once
    
    @report.generate_file('output.pdf', :option => :value)
  end
  
  def test_events_should_return_Report_Events
    assert_instance_of ThinReports::Report::Events, @report.events
  end
  
  def test_page_should_return_the_current_page
    @report.use_layout(data_file('basic_layout1.tlf'))
    @report.start_new_page
    
    assert_instance_of ThinReports::Core::Page, @report.page
  end
  
  def test_page_count_should_return_total_page_count
    @report.use_layout(data_file('basic_layout1.tlf'))
    2.times { @report.start_new_page }
    
    assert_equal @report.page_count, 2
  end
  
  def test_finalize_should_finalize_report
    @report.finalize
    assert_equal @report.finalized?, true
  end
  
  def test_finalized_asker_should_return_false_when_report_has_not_been_finalized_yet
    assert_equal @report.finalized?, false
  end
  
  def test_finalized_asker_should_return_true_when_report_is_already_finalized
    @report.finalize
    assert_equal @report.finalized?, true
  end
  
  def test_list_should_create_new_page_when_page_is_not_created
    @report.use_layout(data_file('basic_list_layout.tlf'))
    @report.list(:list)
    
    refute_nil @report.page
  end
  
  def test_list_should_create_new_page_when_page_is_finalized
    @report.tap do |r|
      r.use_layout(data_file('basic_list_layout.tlf'))
      r.start_new_page
      r.page.finalize
    end
    @report.list(:list)
    
    assert_equal @report.page.finalized?, false
  end
  
  def test_list_should_properly_return_shape_with_the_specified_id
    @report.use_layout(data_file('basic_list_layout.tlf'))
    
    assert_equal @report.list(:list).id, 'list'
  end
  
  def test_Base_create_should_finalize_report
    report = Report::Base.create do |r|
      assert_instance_of Report::Base, r
    end
    assert_equal report.finalized?, true
  end
  
  def test_Base_create_should_raise_when_no_block_given
    assert_raises ArgumentError do
      Report::Base.create
    end
  end
  
  def test_Base_generate_should_properly_generate_when_type_is_specified
    flexmock(Report::Base).new_instances.
      should_receive(:generate).
      with(:pdf, :option => :value).once
    
    flexmock(Report::Base).
      should_receive(:create).
      with({:layout => 'layout.tlf'}, Proc).
      and_return(Report::Base.new).once
    
    Report::Base.generate(:pdf, :report    => {:layout => 'layout.tlf'},
                                :generator => {:option => :value}) {}
  end
  
  def test_Base_generate_should_properly_generate_when_type_is_omitted
    flexmock(Report::Base).new_instances.
      should_receive(:generate).
      with({}).once
    
    flexmock(Report::Base).
      should_receive(:create).
      with({}, Proc).
      and_return(Report::Base.new).once
    
    Report::Base.generate {}
  end
  
  def test_Base_generate_file_should_properly_generate_file_when_type_is_specified
    flexmock(Report::Base).new_instances.
      should_receive(:generate_file).
      with(:pdf, 'output.pdf', {}).once
    
    flexmock(Report::Base).
      should_receive(:create).
      with({:layout => 'layout.tlf'}, Proc).
      and_return(Report::Base.new).once
    
    Report::Base.generate_file(:pdf, 'output.pdf', :report => {:layout => 'layout.tlf'}) {}
  end
  
  def test_Base_generate_file_should_properly_generate_file_when_type_is_omitted
    flexmock(Report::Base).new_instances.
      should_receive(:generate_file).
      with('output.pdf', :option => :value).once
      
    flexmock(Report::Base).
      should_receive(:create).
      with({}, Proc).
      and_return(Report::Base.new).once
    
    Report::Base.generate_file('output.pdf', :generator => {:option => :value}) {}
  end
  
  def test_Base_generate_should_raise_when_no_block_given
    assert_raises ArgumentError do
      Report::Base.generate(:pdf)
    end
  end
  
  def test_Base_generate_file_should_raise_when_no_block_given
    assert_raises ArgumentError do
      Report::Base.generate_file(:pdf, 'output.pdf')
    end
  end
  
  def test_Base_extract_options_should_return_as_report_option_the_value_which_has_report_in_a_key
    report, generator = Report::Base.send(:extract_options!, [{:report => {:layout => 'hoge.tlf'}}])
    assert_equal report[:layout], 'hoge.tlf'
  end
  
  def test_Base_extract_options_should_operate_an_argument_destructively
    args = [:pdf, 'output.pdf', {:report => {:layout => 'foo.tlf'}}]
    Report::Base.send(:extract_options!, args)
    assert_equal args, [:pdf, 'output.pdf']
  end
  
  def test_Base_extract_options_should_include_the_layout_key_in_the_report_option
    report, generator = Report::Base.send(:extract_options!, [{:layout => 'hoge.tlf'}])
    assert_equal report[:layout], 'hoge.tlf'
  end
  
  def test_Base_extract_options_should_give_priority_to_the_value_of_the_layout_key_over_in_the_report_option
    report, generator = Report::Base.send(:extract_options!,
                                          [{:report => {:layout => 'foo.tlf'}, :layout => 'hoge.tlf'}])
    assert_equal report[:layout], 'hoge.tlf'
  end
  
  def test_Base_extract_options_should_return_as_generator_option_the_value_which_has_generator_in_a_key
    report, generator = Report::Base.send(:extract_options!,
                                          [{:generator => {:option => 'value'}}])
    assert_equal generator[:option], 'value'
  end
  
  def test_Base_extract_options_should_give_priority_to_the_value_of_other_keys_over_in_the_generator_option
    report, generator = Report::Base.send(:extract_options!,
                                          [{:generator => {:option => 'value1'}, :option => 'value2'}])
    assert_equal generator[:option], 'value2'
  end
  
  def test_Base_extract_options_should_return_all_the_values_except_the_report_option_as_a_generator_option
    report, generator = Report::Base.send(:extract_options!,
                                          [{:report => {:layout => 'foo.tlf'}, :layout => 'hoge.tlf',
                                            :generator_opt1 => 'value1', :generator_opt2 => 'value2'}])
    assert_equal generator.values_at(:generator_opt1, :generator_opt2),
                 ['value1', 'value2']
  end
end
