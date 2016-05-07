# coding: utf-8

module Thinreports
  module Core::Shape

    class Basic::BlockFormat < Basic::Format
      config_reader :value

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
