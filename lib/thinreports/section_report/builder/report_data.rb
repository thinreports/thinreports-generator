# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Builder
      module ReportData
        Main = Struct.new :schema, :groups
        Group = Struct.new :headers, :details, :footers
        Section = Struct.new :schema, :items, :min_height
      end
    end
  end
end
