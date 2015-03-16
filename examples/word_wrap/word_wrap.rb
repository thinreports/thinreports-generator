# coding: utf-8

example :word_wrap, 'Word-wrap property of TextBlock' do |t|
  Thinreports::Report.generate :filename => t.output_filename do
    use_layout t.layout_filename
    start_new_page

    page.item(:locale).value('ja')

    text = 'Thinreports は Ruby 向けのオープンソース帳票・PDF ツールです。'
    page.values :single_none => text,
                :single_break_word => text,
                :multiple_none => text,
                :multiple_break_word => text

    start_new_page

    page.item(:locale).value('en')

    text = 'Thinreports is the OSS reporting tool for Ruby-lang.'
    page.values :single_none => text,
                :single_break_word => text,
                :multiple_none => text,
                :multiple_break_word => text
  end
end
