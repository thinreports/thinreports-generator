# frozen_string_literal: true

example :list_events, 'Basic list events' do |t|
  Thinreports::Report.generate filename: t.output_filename do |report|
    report.use_layout t.layout_filename

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
  end
end
