# coding: utf-8

module ThinReports
  module Generator
    
    # @private
    module PDF::ParseColor
      # @param [String] color
      # @return [String]
      def parse_color(color)
        color = color.downcase
        
        unless color =~ /^#?[\da-f]{6}$/
          find_color_from_name(color)
        else
          color.delete('#')
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
      }
      
      def find_color_from_name(name)
        unless color = SUPPORTED_COLOR_NAMES[name]
          raise ThinReports::Errors::UnsupportedColorName, name
        end
        color
      end
    end
    
  end
end