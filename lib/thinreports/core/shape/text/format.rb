module Thinreports
  module Core::Shape

    class Text::Format < Basic::Format

      config_reader :texts
      config_reader valign: %w( style vertical-align )
      config_reader line_height: %w( style line-height )
    end

  end
end
