# coding: utf-8

module Thinreports
  module Core::Shape

    class Text::Format < Basic::Format
      config_reader :text, :box, :valign
      config_reader svg_content: %w( svg content ),
                    line_height: %w( line-height )

      class << self
      private

        # @see Thinreports::Core::Shape::Basic::Format#build_internal
        def build_internal(raw_format)
          new(raw_format) do |f|
            clean_with_attributes(f.svg_content)
          end
        end
      end
    end

  end
end
