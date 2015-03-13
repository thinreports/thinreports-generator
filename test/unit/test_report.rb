# coding: utf-8

require 'test_helper'

class ThinReports::TestReport < Minitest::Test
  include ThinReports::TestHelper

  # Alias
  Report = ThinReports::Report

  def test_new
    assert_instance_of Report::Base, Report.new
  end

  def test_create
    assert_instance_of Report::Base, Report.create {}
  end
end
