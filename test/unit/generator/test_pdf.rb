# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::TestPdf < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Pdf = ThinReports::Generator::Pdf
  
  def test_new_should_set_title_as_metadata
    report = create_basic_report {|r| r.start_new_page }
    
    flexmock(Pdf::Document).should_receive(:new).
      with(Hash, :Title => 'Basic Layout').once
    
    Pdf.new(report, {})
  end
end