# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module List
        TYPE_NAME = 'list'.freeze
      end
    end
  end
end

require_relative 'list/format'
require_relative 'list/manager'

require_relative 'list/page'
require_relative 'list/page_state'

require_relative 'list/section_format'
require_relative 'list/section_interface'
require_relative 'list/section_internal'
