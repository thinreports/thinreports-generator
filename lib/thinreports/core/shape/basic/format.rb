# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Basic
        class Format < Core::Format::Base
          include Utils

          config_reader :type, :id
          config_reader :style
          config_checker true, :display
        end
      end
    end
  end
end
