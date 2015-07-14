# coding: utf-8

gem 'minitest' # for 1.9.3
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/unit'
require 'mocha/mini_test'

require 'digest/sha1'
require 'pathname'
require 'chunky_png'
require 'thinreports'

module Thinreports::TestHelper
  ROOT = Pathname.new(File.expand_path('..', __FILE__))

  def setup
    Thinreports::TestHelper.disable_stderr
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

  def read_data_file(filename)
    File.read(data_file(filename))
  end

  def temp_file(extname = 'pdf')
    filename = (('a'..'z').to_a + (0..9).to_a).shuffle[0, 8].join + ".#{extname}"
    temp_path.join(filename).to_s
  end

  def temp_path
    ROOT.join('tmp')
  end

  @@original_stderr = nil

  def self.disable_stderr
    unless $stdout.is_a? StringIO
      @@original_stderr = $stderr
      $stderr = StringIO.new
    end
  end

  def self.enable_stderr
    $stderr = @@original_stderr
  end
end

Minitest.after_run { Thinreports::TestHelper.enable_stderr }
