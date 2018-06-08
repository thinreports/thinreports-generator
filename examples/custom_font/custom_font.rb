# frozen_string_literal: true

example :custom_font, 'Custom fonts' do |t|
  Thinreports.configure do |config|
    config.register_font('Gen Shin Gothic',
      normal: t.resource('GenShinGothic-Normal.ttf')
    )
  end

  text = <<TEXT
ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
日本語gkにほんご
TEXT

  report = Thinreports::Report.new layout: t.layout_filename
  report.start_new_page do |page|
    page.values(
      gen_shin_gothic: text,
      ipa_gothic: text,
      helvetica: text,
      courier_new: text,
      times_new_roman: text
    )
  end
  report.generate filename: t.output_filename
end
