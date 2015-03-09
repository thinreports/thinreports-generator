# coding: utf-8

require 'rubygems'
require 'minitest/spec'
require 'minitest/unit'
require 'flexmock/test_unit'

require 'fileutils'
require 'digest/sha1'
require 'pathname'

require 'thinreports'

Minitest.autorun

module ThinReports::TestHelper
  include FlexMock::TestCase

  ROOT = Pathname.new(File.expand_path('..', __FILE__))

  def teardown
    super
    clear_output
  end

  def skip_if_ruby19
    if RUBY_VERSION > '1.9'
      skip('This test is not required more than Ruby 1.9.')
    end
  end

  def skip_if_ruby18
    if RUBY_VERSION < '1.9'
      skip('This test is not required Ruby 1.8 below.')
    end
  end

  def create_basic_report(file, &block)
    report = ThinReports::Report.new :layout => data_file(file)
    block.call(report) if block_given?
    report
  end

  def create_basic_layout(file)
    ThinReports::Layout.new(data_file(file))
  end

  def create_basic_layout_format(file)
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
