# coding: utf-8

module Thinreports
  module Core::Shape

    class ImageBlock::Format < Basic::BlockFormat
      config_reader position_x: %w( position-x ),
                    position_y: %w( position-y )
    end

  end
end
