# coding: utf-8

CaseRunner.current :character_spacing

ThinReports::Report.generate_file(CaseRunner.output_file, :layout => CaseRunner.layout_file) do
  start_new_page
end
