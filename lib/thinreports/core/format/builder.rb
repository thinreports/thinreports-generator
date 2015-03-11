# coding: utf-8

require 'json'

module ThinReports
  module Core::Format

    # @private
    module Builder
      def build(*args)
        build_internal(*args)
      rescue ThinReports::Errors::Basic => e
        raise
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
        pattern = /<!--#{level}SHAPE(.*?)SHAPE#{level}-->/

        format.layout.scan(pattern) do |m|
          shape_format = block.call(*parsed_format_and_shape_type(m.first))
          format.shapes[shape_format.id.to_sym] = shape_format
        end
        format.layout.gsub!(pattern, '')
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
