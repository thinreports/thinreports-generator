# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Basic
        class Internal < Base::Internal
          # Delegate to Format's methods
          format_delegators :id, :type

          def style
            @style ||= Style::Graphic.new(format)
          end

          def type_of?(type_name)
            [:basic, type].include?(type_name)
          end

          def identifier
            "#{id}#{style.identifier}"
          end
        end
      end
    end
  end
end
