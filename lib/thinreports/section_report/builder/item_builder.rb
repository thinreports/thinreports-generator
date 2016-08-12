module Thinreports
  module SectionReport
    module Bulder
      class ItemBuilder
        def initialize(item_schema)
          @item = Core::Shape::Interface(nil, item_schema)
        end

        def build(item_params)
          return item unless item_params

          params = normalize_params(item_params)

          # TODO:
          # * PageNumber#format
          # * TextBlock#format_enabled

          item.visible(params[:display]) if params.key?(:display)
          item.value(params[:value]) if params.key?(:value)
          item.styles(params[:styles]) if params.key?(:styles)

          item
        end

        private

        attr_reader :item

        def normalize_params(params)
          params.is_a?(Hash) ? params : { value: params }
        end
      end
    end
  end
end
