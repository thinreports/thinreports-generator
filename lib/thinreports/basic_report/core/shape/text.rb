# frozen_string_literal: true

module Thinreports
  module BasicReport
    module Core
      module Shape
        module Text
          TYPE_NAME = 'text'
        end
      end
    end
  end
end

require_relative 'text/format'
require_relative 'text/internal'
require_relative 'text/interface'
