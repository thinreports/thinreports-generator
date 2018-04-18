# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module StackView
        TYPE_NAME = 'stack-view'.freeze
      end
    end
  end
end

require_relative 'stack_view/format'
require_relative 'stack_view/interface'
require_relative 'stack_view/internal'

require_relative 'stack_view/row_format'
