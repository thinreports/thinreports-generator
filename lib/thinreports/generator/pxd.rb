# coding: utf-8

require 'stringio'
require 'tempfile'

module ThinReports
  module Generator
    
    class Pxd < Base
      require 'thinreports/generator/pxd/helper'
      
      autoload :PageRenderer, 'thinreports/generator/pxd/page_renderer'
      autoload :ListRenderer, 'thinreports/generator/pxd/list_renderer'
      
      include Helper
      
      # @param report (see ThinReports::Generator::Base#initialize)
      # @param [Hash] options See http://www.pxdoc.com/tech/wiki.cgi?page=pxd
      def initialize(report, options)
        super
        @renderers = {}
      end
      
      # @see ThinReports::Generator::Base#generate
      def generate
        output = StringIO.new('', 'r+:UTF-8')
        render_start_pxd(output)
        
        report.pages.each do |page|
          render_page(output, page)
        end
        
        render_end_pxd(output)
        output.string
      end
      
      # @see ThinReports::Generator::Base#generate_file
      def generate_file(filename)
        File.open(filename, 'w') {|f| f << generate }
      end
    
    private
    
      def renderer(page)
        @renderers[page.layout.format.identifier] ||=
            PageRenderer.new(page.layout.format)
      end
      
      def render_page(output, page)
        output << unless page.blank?
          content_tag(:page, renderer(page).render(page.manager), nil,
                      :escape => false)
        else
          tag(:page)
        end
      end
      
      def render_start_pxd(output)
        format = default_layout.format
        attrs  = @options.merge('title'       => format.report_title,
                                'paper-type'  => format.page_paper_type,
                                'orientation' => format.page_orientation,
                                'width'       => format.page_width,
                                'height'      => format.page_height,
                                'dpi'         => '72')
        output << tag(:pxd, attrs, true)
      end
      
      def render_end_pxd(output)
        output << '</pxd>'
      end
    end
    
  end
end