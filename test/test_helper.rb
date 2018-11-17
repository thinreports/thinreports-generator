# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/unit'
require 'mocha/minitest'
require 'pdf/inspector'

require 'digest/sha1'
require 'pathname'
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

  def analyze_pdf_images(pdf_data)
    analyzer = PDF::Inspector::XObject.analyze(pdf_data)
    analyzer.page_xobjects
      .reduce(:merge).values
      .select { |o| o.hash[:Subtype] == :Image }
  end
end
