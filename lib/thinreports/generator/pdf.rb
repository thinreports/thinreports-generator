# coding: utf-8

begin
  gem 'prawn', '2.1.0'
  require 'prawn'
rescue LoadError
  puts 'Thinreports requires Prawn = 2.1.0. ' +
       'Please `gem install prawn -v 2.1.0` and try again.'
end

module Thinreports
  module Generator

    class PDF
      # @return [Thinreports::Report::Base]
      attr_reader :report

      # @return [Hash]
      attr_reader :options

      # @param [Thinreports::Report::Base] report
      # @param [Hash] options
      # @option options [Hash] :security (nil)
      #   See Prawn::Document#encrypt_document
      def initialize(report, options = {})
        report.finalize

        @report  = report.internal
        @options = options || {}

        title = default_layout ? default_layout.format.report_title : nil

        @document = Document.new(options, Title: title)
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

require 'thinreports/generator/pdf/prawn_ext'
require 'thinreports/generator/pdf/document'
require 'thinreports/generator/pdf/drawer/base'
require 'thinreports/generator/pdf/drawer/page'
require 'thinreports/generator/pdf/drawer/list'
require 'thinreports/generator/pdf/drawer/list_section'
