# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module List
        class PageState < Basic::Internal
          attr_reader :rows

          attr_accessor :height
          attr_accessor :header
          attr_accessor :no
          attr_accessor :manager

          def initialize(*args)
            super(*args)

            @rows = []
            @height = 0
            @finalized = false

            @header = nil
          end

          def style
            @style ||= Style::Basic.new(format)
          end

          def finalized?
            @finalized
          end

          def finalized!
            @finalized = true
          end

          def type_of?(type_name)
            type_name == List::TYPE_NAME
          end
        end

        # Alias to List::PageState.
        # @see Thinreports::Core::Shape::List::PageState
        List::Internal = List::PageState
      end
    end
  end
end
