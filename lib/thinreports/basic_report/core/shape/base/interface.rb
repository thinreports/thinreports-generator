# frozen_string_literal: true

module Thinreports
  module BasicReport
    module Core
      module Shape
        module Base
          # @abstract
          class Interface
            include Utils
            extend  Forwardable

            def self.internal_delegators(*args)
              def_delegators :internal, *args
            end
            private_class_method :internal_delegators

            attr_reader :internal

            def initialize(parent, format, internal = nil)
              @internal = internal || init_internal(parent, format)
            end

            def copy(parent)
              self.class.new(parent, internal.format, internal.copy(parent))
            end

            private

            # @param [Thinreports::BasicReport::Report::Page, Thinreports::BasicReport::Core::Shape::List::SectionInterface] parent
            # @param [Thinreports::BasicReport::Core::Shape::Basic::Format] format
            # @return [Thinreports::BasicReport::Core::Shape::Basic::Internal]
            # @abstract
            def init_internal(parent, format)
              raise NotImplementedError
            end
          end
        end
      end
    end
  end
end
