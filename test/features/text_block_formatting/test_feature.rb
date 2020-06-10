# frozen_string_literal: true

require 'feature_test'
require 'date'

class TestTextBlockFormattingFeature < FeatureTest
  feature :text_block_formatting do
    report = Thinreports::Report.new

    report.start_new_page layout: template_path do |page|
      # Basic
      page.item(:basic).value = 1980

      # Date
      page.values(
        date_with_date: Date.new(2019, 1, 1),
        date_with_time: Time.new(2019, 1, 1, 12, 30, 45),
        date_with_not_a_date: 'Not applied'
      )

      # Number
      page.values(
        number_with_delimiter: 9_999_999,
        number_with_precision: 1_000.1,
        number_with_delimiter_and_precision: 198_000,
        number_with_valid_string_number: '198000',
        number_with_invalid_string_number: 'Not applied'
      )

      # Padding
      page.values(
        padding_left: '1234',
        padding_right: 'abcd',
        padding_with_value_longer_than_length: '9' * 11,
        padding_with_number_value: 9_999,
        padding_with_blank_value: ''
      )

      # Basic (multi-line)
      page.item(:multiline_basic).value = 'TitleTitle'

      # Date (multi-line)
      page.item(:multiline_date).value = Date.new(2019, 2, 1)

      # Number (multi-line)
      page.item(:multiline_number).value = 123_456

      # Padding (multi-line)
      page.item(:multiline_padding).value = '123'
    end

    assert_pdf report.generate
  end
end
