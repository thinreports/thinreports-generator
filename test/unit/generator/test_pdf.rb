# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::TestPDF < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  PDF = ThinReports::Generator::PDF
  
  def test_new_should_set_empty_title_when_the_default_layout_is_not_set
    report = ThinReports::Report.new
    report.start_new_page :layout => data_file('basic_layout1.tlf')

    flexmock(PDF::Document).should_receive(:new).
      with(Hash, :Title => nil).once

    PDF.new(report, {})
  end

  def test_new_should_set_title_as_metadata
    report = create_basic_report('basic_layout1.tlf') {|r| r.start_new_page }
    
    flexmock(PDF::Document).should_receive(:new).
      with(Hash, :Title => 'Basic Layout').once
    
    PDF.new(report, {})
  end
end
