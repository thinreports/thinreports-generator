# coding: utf-8

begin
  require 'json'
rescue LoadError
  puts 'ThinReports requires json >= 1.4.6. ' +
       'Please `gem install json` and try again.'
end

module ThinReports
  module Core::Format
    
    # @private
    module Builder
      def build(*args)
        build_internal(*args)
      rescue ThinReports::Errors::Basic => e
        raise e
      rescue => e
        raise ThinReports::Errors::InvalidLayoutFormat
      end
      
    private
      
      # @abstract
      def build_internal(*args)
        raise NotImplementedError
      end

      # @param [ThinReports::Core::Format::Base] format
      # @param [Hash] options
      def build_layout(format, options = {}, &block)
        level = '-' * ((options[:level] || 1 ) - 1)

        format.layout.gsub!(/<!--#{level}SHAPE(.*?)SHAPE#{level}-->/) do
          shape_format = block.call(*parsed_format_and_shape_type($1))
          
          format.shapes[shape_format.id.to_sym] = shape_format
          shape_tag(shape_format)
        end
      end
      
      # @param [String] svg
      def clean(svg)
        svg.gsub!(/<!--.*?-->/, '')
      end
      
      # @param [String] svg
      def clean_with_attributes(svg)
        clean(svg)
        svg.gsub!(/ x\-[a-z\d\-]+?=".*?"/, '')
        svg.gsub!(/ class=".*?"/, '')        
      end
      
      def shape_tag(format)
        %{<%= r(:"#{format.id}")%>}
      end
      
      def parsed_format_and_shape_type(json_string)
        f = parse_json(json_string)
        [ f['type'], f ]
      end

      def parse_json(json_string)
        JSON.parse(json_string)
      end
    end
    
  end
end
