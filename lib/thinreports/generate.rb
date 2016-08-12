require_relative 'section_report/generate'

module Thinreports
  class Generate
    def initialize(filename = nil)
      @filename = filename
    end

    def call(report_params)
      SectionReport::Generate.new(filename).call(report_params)
    end

    private

    attr_reader :filename
  end
end
