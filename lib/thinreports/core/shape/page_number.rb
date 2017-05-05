# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module PageNumber
        TYPE_NAME = 'page-number'.freeze
      end
    end
  end
end

require_relative 'page_number/format'
require_relative 'page_number/internal'
require_relative 'page_number/interface'
