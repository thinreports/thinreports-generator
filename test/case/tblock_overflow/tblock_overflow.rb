# coding: utf-8

CaseRunner.current :tblock_overflow

report = ThinReports::Report.new :layout => CaseRunner.layout_file
report.start_new_page do |page|
  page.values(:truncate => 'The string overflowing from the area will be truncated', 
              :truncate_ja => '領域から溢れたテキストは切り捨てられます。', 
              :truncate_m => 'The string overflowing from the area will be truncated')

  page.values(:fit => 'The string overflowing from the area will be reduced', 
              :fit_ja => '領域から溢れたテキストは縮小されます。', 
              :fit_m => '複数行モードでも、領域から溢れたテキストは自動的に縮小され折り返して表示されます。')
  
  page.values(:expand => 'If a string was overflowed, a box will be expanded automatically', 
              :expand_ja => 'テキストが溢れた場合、ボックスが自動的に拡張されます。', 
              :expand_m => 'If a string was overflowed, a box will be expanded automatically')
end

report.generate_file(CaseRunner.output_file)
