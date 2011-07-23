# coding: utf-8

require 'erb'

module ThinReports
  module Generator
    
    # @private
    class Pxd::PageRenderer
      include Pxd::Helper
      
      def initialize(format)
        @engine  = ERB.new(read_layout(format))
        @manager = {}
        @lists   = {}
      end
      
      # @param [ThinReports::Core::Shape::Manager::Internal] manager
      # @return [String]
      def render(manager)
        @manager = manager
        @engine.result(binding)
      end
      
      def render_shape(id)
        return '' unless shape = @manager.final_shape(id)
        
        shape = shape.internal
        case 
        when shape.type_of?(:tblock)
          render_tblock(shape)
        when shape.type_of?(:list)
          render_list(shape)
        when shape.type_of?(:text)
          render_text(shape)
        else
          render_basic(shape)
        end
      end
      alias_method :r, :render_shape
      
    private
    
      def render_basic(shape)
        tag(shape.svg_tag, shape.attributes)
      end
      
      def render_text(shape)
        content_tag(shape.svg_tag, shape.svg_content,
                    shape.attribute, :escape => false)
      end
      
      def render_tblock(shape)
        value = h(shape.real_value)
        value = if shape.multiple?
          value.gsub(/\r\n|\n/, '<tBreak/>')
        else
          value.gsub(/\r\n|\n/, ' ')
        end
        content_tag(shape.svg_tag, value, shape.attributes, :escape => false)
      end
      
      def render_list(shape)
        renderer = @lists[shape.id] ||= Pxd::ListRenderer.new
        renderer.render(shape)
      end
      
      def read_layout(format)
        format.layout.gsub(/ x\-[a-z\d\-]+?=".*?"/, '').
                      gsub(/ class=".*?"/, '')
      end
    end
    
  end
end