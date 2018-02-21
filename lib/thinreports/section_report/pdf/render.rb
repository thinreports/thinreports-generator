require_relative 'renderer/group_renderer'

module Thinreports
  module SectionReport
    module PDF
      class Render
        def initialize(pdf)
          @group_renderer = Renderer::GroupRenderer.new(pdf)
        end

        # @param [SectionReport::Builder::ReportData::Main] report
        def call!(report)
          report.groups.each { |group| group_renderer.render(group) }
        end

        private

        attr_reader :group_renderer
      end
    end
  end
end
