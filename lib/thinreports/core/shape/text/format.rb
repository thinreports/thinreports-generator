# coding: utf-8

module Thinreports
  module Core::Shape

    class Text::Format < Basic::Format

      config_reader :texts
      config_reader valign: %w( style vertical-align )
      config_reader line_height: %w( style line-height )

      # FIXME: make be DRY
      def box
        @box ||= {
          'x' => attributes['x'],
          'y' => attributes['y'],
          'width' => attributes['width'],
          'height' => attributes['height']
        }
      end
    end

  end
end
