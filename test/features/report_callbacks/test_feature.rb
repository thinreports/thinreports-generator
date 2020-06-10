# frozen_string_literal: true

require 'feature_test'

class TestReportCallbacks < FeatureTest
  feature :report_callbacks do
    report = Thinreports::Report.new layout: template_path

    report.on_page_create do |page|
      page.item(:text2).value('Rendered by on_page_create')
    end

    report.start_new_page
    report.start_new_page

    assert_pdf report.generate
  end
end
