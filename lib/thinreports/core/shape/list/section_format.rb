# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class List::SectionFormat < Manager::Format
      config_reader :height
      config_reader :relative_left => %w( translate x ),
                    :relative_top  => %w( translate y )
      
      config_reader :layout      => %w( svg content ),
                    :svg_tag     => %w( svg tag ),
                    :svg_attrs   => %w( svg attrs )
      
      class << self
      private
        
        def build_internal(raw_format)
          new(raw_format) do |f|
            build_layout(f, :level => 2) do |type, shape_format|
              Core::Shape::Format(type).build(shape_format)
            end
            clean(f.layout)
          end
        end
      end
      
    end    
    
  end
end
