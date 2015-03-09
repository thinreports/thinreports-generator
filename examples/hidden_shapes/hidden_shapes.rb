# coding: utf-8

example :hidden_shapes, 'Generate PDF that contains hidden shapes' do |t|
  ThinReports::Report.generate(:filename => t.output_filename) do
    use_layout t.layout_filename

    2.times { list(:List).add_row }
  end
end
