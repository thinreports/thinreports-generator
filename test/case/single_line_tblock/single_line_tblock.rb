# coding: utf-8

CaseRunner.current :single_line_tblock

ThinReports::Report.generate_file(CaseRunner.output_file) do
  use_layout(CaseRunner.layout_file)
  
  start_new_page
  
  # When Japanese is set to the Tblock to which the Helvetica font is set.
  page.item(:fallback_to_ipafont).value('IPA明朝に自動的にフォールバックされる')
  
  # When multi-line text is set.
  page.item(:set_multiline_text).value("１行目\n2行目\n3行目\n4行目\n5行目")
end
