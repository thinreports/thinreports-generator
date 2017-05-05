# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Text
        TYPE_NAME = 'text'.freeze
      end
    end
  end
end

require_relative 'text/format'
require_relative 'text/internal'
require_relative 'text/interface'
