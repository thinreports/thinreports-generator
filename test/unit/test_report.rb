# coding: utf-8

require 'test/unit/helper'

class ThinReports::TestReport < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Report = ThinReports::Report
  
  def test_new_should_delegate_to_Base_new
    flexmock(Report::Base).should_receive(:new).once
    Report.new
  end
  
  def test_create_should_delegate_to_Base_create
    flexmock(Report::Base).should_receive(:create).once
    Report.create
  end
  
  def test_generate_should_delegate_to_Base_generate
    flexmock(Report::Base).should_receive(:generate).once
    Report.generate
  end
  
  def test_generate_file_should_delegate_to_Base_generate_file
    flexmock(Report::Base).should_receive(:generate_file).once
    Report.generate_file
  end
end