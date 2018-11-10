# frozen_string_literal: true

require 'feature_test'

class TestListEvents < FeatureTest
  feature :list_events do
    report = Thinreports::Report.new layout: template_path

    report.list.header title: 'Prices'

    report.list do |list|
      price_for = { page: 0, all: 0 }

      list.on_page_finalize do
        price_for[:all] += price_for[:page]
        price_for[:page] = 0
      end

      list.on_page_footer_insert do |footer|
        footer.item(:price).value(price_for[:page])
      end

      list.on_footer_insert do |footer|
        footer.item(:price).value(price_for[:all])
      end

      [100, 200, 250, 50, 100, 20, 30, 50, 100, 100].each do |price|
        list.add_row price: price
        # Calculate sum price for each page of list
        price_for[:page] += price
      end
    end

    assert_pdf report.generate
  end
end
