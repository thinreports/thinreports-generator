# frozen_string_literal: true

require_relative 'section_report/generate'

module Thinreports
  class Generate
    def call(report_params, filename: nil)
      SectionReport::Generate.new.call(report_params, filename: filename)
    end
  end
end
