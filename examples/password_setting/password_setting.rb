# coding: utf-8

example :password_setting, 'Set password to open' do |t|
  report = Thinreports::Report.new :layout => t.layout_filename
  report.start_new_page
  report.generate(:filename => t.output_filename, :security => {
    :user_password  => 'password',
    :owner_password => :random
  })
end
