# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::TestTextBlockSinglelineFeature < Thinreports::FeatureTest[__dir__]
  feature do
    report = Thinreports::BasicReport::Report.new layout: template_path
    report.start_new_page

    report.page.item(:fallback_to_ipafont).value('IPA明朝に自動的にフォールバックされる')
    report.page.item(:set_multiline_text).value("１行目\n2行目\n3行目\n4行目\n5行目")

    assert_pdf report.generate
  end
end
