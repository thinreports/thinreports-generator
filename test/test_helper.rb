# coding: utf-8

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/unit'
require 'mocha/mini_test'

require 'digest/sha1'
require 'pathname'
require 'chunky_png'
require 'thinreports'

require 'schema_helper'

module Thinreports::TestHelper
  ROOT = Pathname.new(File.expand_path('..', __FILE__))

  include Thinreports::SchemaHelper

  def assert_deprecated(&block)
    _out, err = capture_io { block.call }
    assert err.to_s.include?('[DEPRECATION]')
  end

  def data_file(*paths)
    ROOT.join('data', *paths).to_s
  end

  def read_data_file(*paths)
    File.read(data_file(*paths))
  end

  def temp_path
    ROOT.join('tmp')
  end

  def teardown
    super
    FileUtils.rm Dir.glob(temp_path.join('*'))
  end
end
