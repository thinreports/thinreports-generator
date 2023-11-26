# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::TestTextOverflowWrapFeature < Thinreports::FeatureTest[__dir__]
  feature do
    report = Thinreports::BasicReport::Report.new layout: template_path
    report.start_new_page

    text = 'Thinreports is a PDF generation tool ' +
           'that provides thinreports-editor and thinreports-generator. ' +
           'Thinreports は thinreports-editor と thinreports-generator を提供するPDF 生成ツールです。'

    report.page.values(
      normal: text,
      anywhere: text,
      disable_break_word_by_space: text
    )

    assert_pdf report.generate
  end
end
