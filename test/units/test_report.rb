# frozen_string_literal: true

require 'test_helper'

class Thinreports::TestReport < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Report = Thinreports::Report

  def test_new
    assert_instance_of Report::Base, Report.new
  end

  def test_create
    assert_instance_of Report::Base, Report.create {}
  end
end
