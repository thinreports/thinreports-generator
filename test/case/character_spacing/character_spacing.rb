# coding: utf-8

CaseRunner.current :character_spacing

ThinReports::Report.generate(:filename => CaseRunner.output_file, :layout => CaseRunner.layout_file) do
  start_new_page
end
