# frozen_string_literal: true

require 'feature_test'

class TestTextWordWrap < FeatureTest
  feature :text_word_wrap do
    report = Thinreports::Report.new layout: template_path
    report.start_new_page

    report.page.item(:locale).value('ja')

    text = 'Thinreports は Ruby 向けのオープンソース帳票・PDF ツールです。'
    report.page.values single_none: text,
                       single_break_word: text,
                       multiple_none: text,
                       multiple_break_word: text

    report.start_new_page

    report.page.item(:locale).value('en')

    text = 'Thinreports is the OSS reporting tool for Ruby-lang.'
    report.page.values single_none: text,
                       single_break_word: text,
                       multiple_none: text,
                       multiple_break_word: text

    assert_pdf report.generate
  end
end
