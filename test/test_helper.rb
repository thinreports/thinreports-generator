# coding: utf-8

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/unit'
require 'mocha/mini_test'

require 'digest/sha1'
require 'pathname'

require 'thinreports'

module ThinReports::TestHelper
  ROOT = Pathname.new(File.expand_path('..', __FILE__))

  def teardown
    super
    clear_output
  end

  def new_report(file, &block)
    report = ThinReports::Report.new layout: data_file(file)
    block.call(report) if block_given?
    report
  end

  def new_layout(file)
    ThinReports::Layout.new(data_file(file))
  end

  def new_layout_format(file)
    ThinReports::Layout::Format.build(data_file(file))
  end

  def clear_output
    FileUtils.rm Dir.glob(temp_path.join('*'))
  end

  def clean_whitespaces(s)
    s.gsub(/^\s*|\n\s*/, '')
  end

  def data_file(filename)
    ROOT.join('data', filename).to_s
  end

  def temp_file(extname = 'pdf')
    filename = (('a'..'z').to_a + (0..9).to_a).shuffle[0, 8].join + ".#{extname}"
    temp_path.join(filename).to_s
  end

  def temp_path
    ROOT.join('tmp')
  end
end
