# coding: utf-8

require 'open-uri'

CaseRunner.current :dynamic_image

image50x50    = CaseRunner.case_resource('img50x50.png')
image200x100  = CaseRunner.case_resource('img200x100.png')
matsukei_logo = open('http://www.matsukei.co.jp/common/image/logo.jpg')

ThinReports::Report.generate_file(:pdf, CaseRunner.output_file) do |r|
  r.use_layout(CaseRunner.layout_file)
  
  r.start_new_page
  
  r.page.values(:pos_top_left       => image50x50,
                :pos_top_center     => image50x50,
                :pos_top_right      => image50x50,
                :pos_center_left    => image50x50,
                :pos_center_center  => image50x50,
                :pos_center_right   => image50x50,
                :pos_bottom_left    => image50x50,
                :pos_bottom_center  => image50x50,
                :pos_bottom_right   => image50x50)
  
  r.page.item(:overflow).src(image200x100)
  
  # It cannot do as follows:
  # 
  #   r.page.item(:logo1).src(matsukei_logo)
  #   r.page.item(:logo2).value(matsukei_logo)
  #   
  r.page.item(:logo1).src(matsukei_logo.path)
  r.page.item(:logo2).value(matsukei_logo.path)
  
  r.page.item(:thinreports_logo).src(open('http://www.thinreports.org/media/i/logo.png'))
  
  r.page.list(:list) do |list|
    3.times { list.add_row :in_list => image50x50 }
  end
end
