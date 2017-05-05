# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module ImageBlock
        class Internal < Basic::BlockInternal
          alias src read_value

          def type_of?(type_name)
            type_name == ImageBlock::TYPE_NAME || super
          end
        end
      end
    end
  end
end
