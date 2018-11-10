# frozen_string_literal: true

require 'test_helper'

class Thinreports::Generator::PrawnExt::TestCalcImageDimensions < Minitest::Test
  class Klass
    prepend Thinreports::Generator::PrawnExt::CalcImageDimensions

    def calc_image_dimensions(options)
      options
    end
  end

  def setup
    @klass = Klass.new
  end

  def test_calc_image_dimensions
    res_options = @klass.calc_image_dimensions(
      auto_fit: [100, 200],
      width: 101,
      height: 199
    )
    assert_equal [100, 200], res_options[:fit]
    refute_includes res_options.keys, :auto_fit

    res_options = @klass.calc_image_dimensions(
      auto_fit: [100, 200],
      width: 99,
      height: 201
    )
    assert_equal [100, 200], res_options[:fit]

    res_options = @klass.calc_image_dimensions(
      auto_fit: [100, 200],
      width: 99,
      height: 199
    )
    refute_includes res_options.keys, :fit
  end
end
