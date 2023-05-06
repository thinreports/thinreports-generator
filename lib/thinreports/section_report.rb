# frozen_string_literal: true

module Thinreports
  Core = BasicReport::Core
  Generator = BasicReport::Generator

  def self.generate(report_params, filename: nil)
    SectionReport::Generate.new.call(report_params, filename: filename)
  end
end

require_relative 'section_report/generate'
