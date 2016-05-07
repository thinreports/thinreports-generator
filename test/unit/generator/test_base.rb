# coding: utf-8

require 'test_helper'

class Thinreports::Generator::TestBase < Minitest::Test
  include Thinreports::TestHelper

  Generator = Thinreports::Generator

  class FooGenerator < Generator::Base; end

  def test_registring_generator
    assert_same FooGenerator, Generator.registry.delete(:foogenerator)
  end

  def test_new
    report = Thinreports::Report.new layout: layout_file.path

    refute report.finalized?
    Generator::Base.new report
    assert report.finalized?
  end

  def test_generate
    report = Thinreports::Report.new layout: layout_file.path

    generator = Generator::Base.new report
    assert_raises NotImplementedError do
      generator.generate
    end
  end

  def test_default_layout
    layout_filename = layout_file.path
    report = Thinreports::Report.new layout: layout_filename

    generator = Generator::Base.new report
    assert_equal layout_filename, generator.default_layout.filename
  end
end
