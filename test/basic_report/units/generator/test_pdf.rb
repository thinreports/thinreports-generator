# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::Generator::TestPDF < Minitest::Test
  include Thinreports::BasicReport::TestHelper

  PDF = Thinreports::BasicReport::Generator::PDF

  def test_default_layout
    layout_filename = layout_file.path
    report = Thinreports::BasicReport::Report.new layout: layout_filename

    generator = PDF.new report
    assert_equal layout_filename, generator.default_layout.filename
  end

  def test_initialize
    report = Thinreports::BasicReport::Report.new layout: layout_file.path
    report.start_new_page

    PDF.new(report)

    assert_equal true, report.finalized?
  end
end
