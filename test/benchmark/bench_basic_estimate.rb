# coding: utf-8

require 'benchmark'

ESTIMATE_LAYOUT = File.expand_path(File.dirname(__FILE__) + '/basic_estimate.tlf')
ESTIMATE_OUTPUT = File.expand_path(File.dirname(__FILE__) + '/basic_estimate.pdf')
ESTIMATE_DATA   = []

# Data 1:
data1 = {:no          => 1234,
         :created_d   => Time.now,
         :customer    => '㈱テストコム',
         :title       => 'PC及び関連機器ご購入について',
         :price       => 1000000,
         :tax         => 50000,
         :total_price => 1050000,
         :details     => []}

0.step(10000, 2) do |t|
  data1[:details] << {:no         => 1 + t,
                   :title      => 'ノートパソコン',
                   :amount     => 4,
                   :unit_price => 200000,
                   :price      => 800000}
  data1[:details] << {:no         => 2 + t,
                   :title      => 'プリンタ',
                   :amount     => 2,
                   :unit_price => 100000,
                   :price      => 200000,
                   :note       => 'トナー×2本含む'}
end
ESTIMATE_DATA << data1

# Data 2:
data2 = {:no          => 3456,
         :created_d   => '2011年1月1日',
         :customer    => '㈱○○○○',
         :title       => '□□□□□□□□□',
         :price       => 100000,
         :tax         => 5000,
         :total_price => 105000,
         :note        => '△' * 40,
         :details     => []}
10000.times do |t|
  data2[:details] << {:no         => t + 1,
                      :title      => '×××××××××',
                      :amount     => 1,
                      :unit_price => 5000,
                      :price      => 5000}
end
ESTIMATE_DATA << data2

puts Benchmark::CAPTION
puts Benchmark.measure {
  report = ThinReports::Report.create do |r|
    r.use_layout ESTIMATE_LAYOUT do |config|
      config.list(:details) do
        use_stores :price       => 0,
                   :total_price => 0
        
        events.on :page_footer_insert do |e|
          e.section.item(:price).value(e.store.price)
          e.store.price = 0
        end
        
        events.on :footer_insert do |e|
          e.section.item(:price).value(e.store.total_price)
        end
      end
    end
    
    ESTIMATE_DATA.each do |data|
      r.start_new_page
      
      r.page.values(:no          => data[:no],
                    :created_d   => data[:created_d],
                    :customer    => data[:customer],
                    :title       => data[:title],
                    :price       => data[:price],
                    :tax         => data[:tax],
                    :total_price => data[:total_price],
                    :note        => data[:note])
      
      data[:details].each do |detail|
        r.page.list(:details).add_row(detail)
        r.page.list(:details) do |list|
          list.store.price       += detail[:price]
          list.store.total_price += detail[:price]
        end
      end
    end
  end
  
  report.generate_file(:pdf, ESTIMATE_OUTPUT)
}