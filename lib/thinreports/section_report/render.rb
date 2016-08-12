module Thinreports
  module SectionReport
    class Render
      def initialize(pdf)
        @pdf = pdf
      end

      def call!(report)
        report.groups.each do |group|
          Renderer::GroupRenderer.new(pdf).render(group)
        end
      end

      private

      attr_reader :pdf
    end
  end
end
