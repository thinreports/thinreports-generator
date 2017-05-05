# frozen_string_literal: true

require 'test_helper'

class Thinreports::Generator::PrawnExt::TestWidthOf < Minitest::Test
  def setup
    @pdf = Prawn::Document.new
  end

  def test_width_of
    text_width = @pdf.width_of('abcd')

    @pdf.character_spacing(1) do
      expected_character_space_width = 1 * 3
      assert_equal text_width + expected_character_space_width, @pdf.width_of('abcd')
    end

    @pdf.character_spacing(1) do
      assert_equal 0, @pdf.width_of('')
    end
  end
end
