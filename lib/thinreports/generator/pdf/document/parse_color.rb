# frozen_string_literal: true

module Thinreports
  module Generator
    class PDF
      module ParseColor
        # @param [String] color
        # @return [String]
        def parse_color(color)
          color = color.downcase

          if color =~ /^#?[\da-f]{6}$/
            color.delete('#')
          else
            find_color_from_name(color)
          end
        end

        private

        # Supported only SAFE COLORS.
        SUPPORTED_COLOR_NAMES = {
          'red'     => 'ff0000',
          'yellow'  => 'fff000',
          'lime'    => '00ff00',
          'aqua'    => '00ffff',
          'blue'    => '0000ff',
          'fuchsia' => 'ff00ff',
          'maroon'  => '800000',
          'olive'   => '808000',
          'green'   => '008800',
          'teal'    => '008080',
          'navy'    => '000080',
          'purple'  => '800080',
          'black'   => '000000',
          'gray'    => '808080',
          'silver'  => 'c0c0c0',
          'white'   => 'ffffff'
        }.freeze

        def find_color_from_name(name)
          color = SUPPORTED_COLOR_NAMES[name]
          raise Thinreports::Errors::UnsupportedColorName, name unless color
          color
        end
      end
    end
  end
end
