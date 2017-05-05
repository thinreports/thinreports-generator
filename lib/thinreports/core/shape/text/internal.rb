# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Text
        class Internal < Basic::Internal
          # Delegate to Format's methods
          format_delegators :texts, :box

          def style
            @style ||= Style::Text.new(format)
          end

          def type_of?(type_name)
            type_name == Text::TYPE_NAME
          end
        end
      end
    end
  end
end
