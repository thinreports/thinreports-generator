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

require 'schema_helper'

module Thinreports::TestHelper
  ROOT = Pathname.new(File.expand_path('..', __FILE__))

  include Thinreports::SchemaHelper

  def data_file(filename)
    ROOT.join('data', filename).to_s
  end

  def read_data_file(filename)
    File.read(data_file(filename))
  end

  def temp_path
    ROOT.join('tmp')
  end

  def teardown
    super
    FileUtils.rm Dir.glob(temp_path.join('*'))
  end
end
