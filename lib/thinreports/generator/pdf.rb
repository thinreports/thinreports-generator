# frozen_string_literal: true

require 'prawn'

module Thinreports
  module Generator
    class PDF
      # @return [Thinreports::Report::Base]
      attr_reader :report

      # @param [Thinreports::Report::Base] report
      # @param [Hash] security (nil)
      def initialize(report, security: nil)
        report.finalize

        @report = report.internal
        title = default_layout ? default_layout.format.report_title : nil

        @document = Document.new(title: title, security: security)
        @drawers = {}
      end

      # @param [String, nil] filename
      # @return [String, nil]
      def generate(filename = nil)
        draw_report
        filename ? @document.render_file(filename) : @document.render
      end

      def default_layout
        report.default_layout
      end

      private

      def draw_report
        report.pages.each do |page|
          draw_page(page)
        end
      end

      def draw_page(page)
        return @document.add_blank_page if page.blank?

        format = page.layout.format
        @document.start_new_page(format)

        drawer(format).draw(page)
      end

      def drawer(format)
        @drawers[format.identifier] ||= Drawer::Page.new(@document, format)
      end
    end
  end
end

require_relative 'pdf/prawn_ext'
require_relative 'pdf/document'
require_relative 'pdf/drawer/base'
require_relative 'pdf/drawer/page'
require_relative 'pdf/drawer/list'
require_relative 'pdf/drawer/list_section'
