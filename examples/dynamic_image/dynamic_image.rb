require 'open-uri'

example :dynamic_image, 'Show images dynamically' do
  image50x50    = resource('img50x50.png')
  image200x100  = resource('img200x100.png')

  Thinreports::Report.generate filename: output_filename do |r|
    r.use_layout(layout_filename)

    r.start_new_page

    r.page.values(pos_top_left:        image50x50,
                  pos_top_center:      image50x50,
                  pos_top_right:       image50x50,
                  pos_center_left:     image50x50,
                  pos_center_center:   image50x50,
                  pos_center_right:    image50x50,
                  pos_bottom_left:     image50x50,
                  pos_bottom_center:   image50x50,
                  pos_bottom_right:    image50x50)

    r.page.item(:overflow).src = image200x100
    r.page[:thinreports_logo] = open('http://www.thinreports.org/assets/logos/thinreports-logo.png')

    r.page.list(:list) do |list|
      3.times { list.add_row in_list: image50x50 }
    end
  end
end
