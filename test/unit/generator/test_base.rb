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
    report = new_report 'layout_text1.tlf'

    refute report.finalized?
    Generator::Base.new report
    assert report.finalized?
  end

  def test_generate
    report = new_report 'layout_text1.tlf'

    generator = Generator::Base.new report
    assert_raises NotImplementedError do
      generator.generate
    end
  end

  def test_default_layout
    report = new_report 'layout_text1.tlf'

    generator = Generator::Base.new report
    assert_equal data_file('layout_text1.tlf'),
                 generator.default_layout.filename
  end
end
