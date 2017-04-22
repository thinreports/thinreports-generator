module Thinreports
  module Core::Shape

    class Basic::Format < Core::Format::Base
      include Utils

      config_reader :type, :id
      config_reader :style
      config_checker true, :display
    end

  end
end
