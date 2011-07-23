# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    class Pxd::ListRenderer
      include Pxd::Helper
      
      def initialize
        @renderers = {}
        @list      = nil
      end

      # @param [ThinReports::Core::Shape::List::PageState] list
      def render(list)
        @list = list
        
        result = String.new
        render_section(result, list.header) if list.header
        
        list.rows.each do |row|
          render_section(result, row)
        end
        result
      end
      
    private

      # @param [String] result
      # @param [ThinReports::Core::Shape::List::SectionInterface] section
      def render_section(result, section)
        internal   = section.internal
        attributes = internal.attributes
        contents   = renderer(internal.section_name).render(section.manager)
        
        # Only for when older than Ver 0.6.0.pre2.
        # Since 0.6.0.pre3, ignore this.
        if internal.relative_top
          attributes['transform'] =
              "translate(#{internal.relative_position.join(',')})"
        end
        
        result << content_tag(internal.svg_tag, contents, attributes,
                              :escape => false)
      end
      
      # @param [Symbol] section_name
      # @return [ThinReports::Generator::Pxd::PageRenderer]
      def renderer(section_name)
        @renderers[section_name] ||=
          Pxd::PageRenderer.new(@list.format.sections[section_name])
      end
      
    end
    
  end
end
