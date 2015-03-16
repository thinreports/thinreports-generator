# coding: utf-8

begin
  gem 'prawn', '1.3.0'
  require 'prawn'
rescue LoadError
  puts 'Thinreports requires Prawn = 1.3.0. ' +
       'Please `gem install prawn -v 1.3.0` and try again.'
end

module Thinreports
  module Generator

    class PDF < Base
      # @param report (see Thinreports::Generator::Base#initialize)
      # @param [Hash] options
      # @option options [Hash] :security (nil)
      #   See Prawn::Document#encrypt_document
      def initialize(report, options)
        super

        title = default_layout ? default_layout.format.report_title : nil

        @document = Document.new(options, Title: title)
        @drawers = {}
      end

      # @see Thinreports::Generator::Base#generate
      def generate(filename = nil)
        draw_report
        filename ? @document.render_file(filename) : @document.render
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

require 'thinreports/generator/pdf/configuration'
require 'thinreports/generator/pdf/prawn_ext'
require 'thinreports/generator/pdf/document'
require 'thinreports/generator/pdf/drawer'
