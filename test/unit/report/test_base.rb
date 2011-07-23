# coding: utf-8

require 'test/unit/helper'

class ThinReports::Report::TestBase < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Report = ThinReports::Report
  
  def setup
    @report = Report::Base.new
  end
  
  def test_initialize_with_options
    flexmock(Report::Internal).
      should_receive(:new).with(Report::Base, {:layout => 'layout.tlf'}).
      and_return(flexmock('report_internal')).once
    
    report = Report::Base.new(:layout => 'layout.tlf')
    assert_equal report.internal.flexmock_name, 'report_internal'
  end
  
  def test_use_layout
    flexmock(@report.internal).
      should_receive(:register_layout).with('layout.tlf', {:default => true}).
      and_return(flexmock('layout_config')).once
    
    assert_equal @report.use_layout('layout.tlf', :default => true).flexmock_name,
                 'layout_config'
  end
  
  def test_start_new_page
    layout = flexmock('layout')
    layout.should_receive(:init_new_page).once
    
    flexmock(@report.internal).
      should_receive(:load_layout).and_return(layout).once.
      should_receive(:add_page).and_return(flexmock('new_page')).once
    
    assert_equal @report.start_new_page.flexmock_name, 'new_page'
  end
  
  def test_start_new_page_raise_when_no_layout_registered_yet
    assert_raises ThinReports::Errors::NoRegisteredLayoutFound do
      @report.start_new_page(:layout => :unknown)
    end
  end
  
  def test_add_blank_page
    blank_page = flexmock('blank_page')
    
    flexmock(ThinReports::Core::BlankPage).
      should_receive(:new).and_return(blank_page)
    
    flexmock(@report.internal).
      should_receive(:add_page).with(blank_page)
    
    @report.add_blank_page
  end
  
  def test_layout_with_nil_return_the_default_layout
    flexmock(@report.internal).
      should_receive(:default_layout).and_return(flexmock('default_layout'))
    
    assert_equal @report.layout.flexmock_name, 'default_layout'
  end
  
  def test_layout_with_id_raise_when_no_layout_found
    assert_raises ThinReports::Errors::UnknownLayoutId do
      @report.layout(:unknown)
    end
  end
  
  def test_generate
    setup_generator do |g|
      g.should_receive(:generate).and_return('output').once
    end
    assert_equal @report.generate(:pdf, {:option => :value}), 'output'
  end
  
  def test_generate_file
    setup_generator do |g|
      g.should_receive(:generate_file).with(String).once
    end
    @report.generate_file(:pdf, 'output.pdf', {:option => :value})
  end
  
  def test_events
    flexmock(@report.internal).
      should_receive(:events).and_return(flexmock('report_events')).once
    
    assert_equal @report.events.flexmock_name, 'report_events'
  end
  
  def test_page
    flexmock(@report.internal).
      should_receive(:page).and_return(flexmock('current_page')).once
    
    assert_equal @report.page.flexmock_name, 'current_page'
  end
  
  def test_page_count
    assert_equal @report.page_count, 0
  end
  
  def test_finalize
    @report.finalize
    assert_equal @report.finalized?, true
  end
  
  def test_Base_create
    report = Report::Base.create do |r|
      assert_instance_of Report::Base, r
    end
    assert_equal report.finalized?, true
  end
  
  def test_Base_create_raise_when_no_block_given
    assert_raises ArgumentError do
      Report::Base.create
    end
  end
  
  def test_Base_generate
    flexmock(Report::Base).new_instances.
      should_receive(:generate).with(:pdf, Hash).once
    
    flexmock(Report::Base).
      should_receive(:create).with(Hash, Proc).
      and_return(Report::Base.new).once
    
    Report::Base.generate(:pdf, :report    => {:layout => 'layout.tlf'},
                                :generator => {:option => :value}) {}
  end
  
  def test_Base_generate_raise_when_no_block_given
    assert_raises ArgumentError do
      Report::Base.generate(:pdf)
    end
  end
  
  def test_Base_generate_file
    flexmock(Report::Base).new_instances.
      should_receive(:generate_file).with(:pdf, String, Hash).once
    
    flexmock(Report::Base).
      should_receive(:create).with(Hash, Proc).
      and_return(Report::Base.new).once
    
    Report::Base.generate_file(:pdf, 'output.pdf', :report    => {:layout => 'layout.tlf'},
                                                   :generator => {:option => :value}) {}
  end
  
  def test_Base_generate_file_raise_when_no_block_given
    assert_raises ArgumentError do
      Report::Base.generate_file(:pdf, 'output.pdf')
    end
  end
  
  def test_Base_init_generate_params_with_empty_options
    Report::Base.send(:init_generate_params, options = {}) {}
    assert_equal options.values_at(:report, :generator), [{}, {}]
  end
  
  def test_Base_init_generate_params_with_configured_options
    options = {:report    => {:layout => 'layout.tlf'},
               :generator => {:option => :value}}
    Report::Base.send(:init_generate_params, options) {}
    
    assert_equal options[:report], {:layout => 'layout.tlf'}
    assert_equal options[:generator], {:option => :value}
  end
  
  def test_Base_init_generate_params_raise_when_no_block_given
    assert_raises ArgumentError do
      Report::Base.send(:init_generate_params)
    end
  end
  
  def setup_generator(&block)
    block.call(generator = flexmock('generator'))
    
    flexmock(ThinReports::Generator).
      should_receive(:new).with(:pdf, @report, Hash).and_return(generator)
  end
end
