# frozen_string_literal: true

require 'test_helper'

class Thinreports::TestReport < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Report = Thinreports::Report

  def test_new
    report = Report.new(layout: layout_file.path)
    assert_instance_of Report::Base, report
  end

  def test_create
    report = Report.create(layout: layout_file.path, &:start_new_page)
    assert_instance_of Report::Base, report
  end

  def test_generate
    result = Report.generate(layout: layout_file.path, &:start_new_page)
    assert_pdf_data result

    assert_raises Thinreports::Errors::LayoutFileNotFound do
      Report.generate(layout: '') { |_| }
    end
  end
end
