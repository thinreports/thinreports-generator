# frozen_string_literal: true

module Thinreports
  module SectionReport
    module Schema
      module Section
        class Base < Schema::Base
          include ItemContainer

          attributes :id, :type, :height

          attribute :display?, 'display'
          attribute :auto_stretch?, 'auto-stretch'

          def initialize(*)
            super

            initialize_items
          end

          def bottom_margin
            @bottom_margin ||= items.each_with_object([]) do |item, margins|
              margins << height - item.bottom if item.affect_bottom_margin?
            end.min
          end
        end

        class Header < Base
          attribute :every_page?, 'every-page'
        end

        class Footer < Base
        end

        class Detail < Base
        end
      end
    end
  end
end
