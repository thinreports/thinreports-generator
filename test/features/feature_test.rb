# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/unit'
require 'pathname'
require 'thinreports'

class FeatureTest < Minitest::Test
  class << self
    attr_reader :name, :desc

    def feature(name, desc = nil, &block)
      @name = name
      @desc = desc
      define_method(:test_feature, &block)
    end
  end

  def dir
    @dir ||= Pathname.new(__dir__).join(feature_name.to_s)
  end

  def path_of(filename)
    dir.join(filename).to_path
  end

  def assert_pdf(actual)
    actual_pdf.binwrite(actual)

    if expect_pdf.exist?
      assert match_expect_pdf?, 'Does not match expect.pdf. Check diff.pdf for details.'
    else
      flunk 'expect.pdf does not exist.'
    end
  end

  def template_path(filename = 'template.tlf')
    dir.join(filename).to_path
  end

  private

  def feature_name
    self.class.name
  end

  def match_expect_pdf?
    system("diff-pdf --output-diff=#{path_of('diff.pdf')} #{expect_pdf} #{actual_pdf}")
  end

  def actual_pdf
    dir.join('actual.pdf')
  end

  def expect_pdf
    dir.join('expect.pdf')
  end
end
