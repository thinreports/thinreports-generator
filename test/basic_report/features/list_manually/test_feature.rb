# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::TestListManuallyFeature < Thinreports::FeatureTest[__dir__]
  feature do
    report = Thinreports::BasicReport::Report.new layout: template_path
    report.list.header do |h|
      h.item(:header).value(report.page.no)
    end

    25.times do |row_index|
      if report.list.overflow?
        report.start_new_page
        report.list.header header: report.page.no
      end

      report.list.page_break if row_index == 15

      report.list.add_row detail: row_index
    end

    assert_pdf report.generate
  end
end
