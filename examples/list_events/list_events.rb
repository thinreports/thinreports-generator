# coding: utf-8

example :list_events, 'Basic list events' do |t|
  Thinreports::Report.generate :filename => t.output_filename do |report|

    # For 0.7.7 or lower
    report.use_layout(t.resource('list_events_0_7_7.tlf'), :id => :for_0_7_7) do |config|
      config.list do
        events.on :page_footer_insert do |e|
          e.section.item(:event_name).value(':page_footer_insert')
        end
        events.on :footer_insert do |e|
          e.section.item(:event_name).value(':footer_insert')
        end
        events.on :page_finalize do |e|
          e.page.item(:event_name).value(':page_finalize')
        end
      end
    end

    report.start_new_page :layout => :for_0_7_7
    report.list.header :event_name => 'Header A'
    2.times {|t| report.list.add_row :row_name => t + 1 }

    report.start_new_page :layout => :for_0_7_7
    report.list.header :event_name => 'Header B'
    8.times {|t| report.list.add_row :row_name => t + 1 }


    # For 0.8 or higher
    report.use_layout t.resource('list_events_0_8.tlf'), :id => :for_0_8

    report.start_new_page :layout => :for_0_8
    report.list.header :title => 'Prices'

    report.list do |list|
      price_for = { :page => 0, :all => 0 }

      [100, 200, 250, 50, 100, 20, 30, 50, 100, 100].each do |price|
        # `list.overflow?` returns true if list has overflowed
        # when `list.add_row` is called at the next time
        if list.overflow?
          list.page_footer :price => price_for[:page]

          price_for[:all] += price_for[:page]
          price_for[:page] = 0
        end

        list.add_row :price => price
        # Calculate sum price for each page of list
        price_for[:page] += price
      end

      list.page_footer :price => price_for[:page]
      price_for[:all] += price_for[:page]

      list.footer do |section|
        section.item(:price).value(price_for[:all])
      end
    end
  end
end
