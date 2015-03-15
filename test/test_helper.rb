# coding: utf-8

require 'digest/sha1'
require 'pathname'
require 'thinreports'

require 'minitest/spec'
require 'minitest/unit'
require 'mocha/mini_test'
require 'minitest/autorun'

module Thinreports::TestHelper
  ROOT = Pathname.new(File.expand_path('..', __FILE__))

  def setup
    Thinreports::TestHelper.disable_output
  end

  def teardown
    super
    clear_temp_files
  end

  def new_report(file, &block)
    report = Thinreports::Report.new layout: data_file(file)
    block.call(report) if block_given?
    report
  end

  def new_layout(file)
    Thinreports::Layout.new(data_file(file))
  end

  def new_layout_format(file)
    Thinreports::Layout::Format.build(data_file(file))
  end

  def clear_temp_files
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

  @@original_stdout = nil
  @@original_stderr = nil

  def self.disable_output
    unless $stdout.is_a? StringIO
      @@original_stdout, @@original_stderr = $stdout, $stderr
      $stdout, $stderr = StringIO.new, StringIO.new
    end
  end

  def self.enable_output
    $stdout, $stderr = @@original_stdout, @@original_stderr
  end
end

Minitest.after_run { Thinreports::TestHelper.enable_output }
