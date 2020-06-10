# frozen_string_literal: true

require 'feature_test'

class TestPageNumberWithList < FeatureTest
  feature :page_number_with_list do
    report = Thinreports::Report.new layout: template_path

    report.start_new_page
    report.page.item(:group_no).value('Group A')

    10.times { report.list.add_row }

    report.start_new_page
    report.page.item(:group_no).value('Group B')

    20.times { report.list.add_row }

    assert_pdf report.generate
  end
end
