require 'test_helper'

class Thinreports::Generator::PDF::TestDocument < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Document = Thinreports::Generator::PDF::Document

  def test_new_without_page_creation
    pdf = Document.new
    assert_equal pdf.internal.page_count, 0
  end

  def test_new_with_zero_margin_canvas
    pdf = Document.new
    assert_equal pdf.internal.page.margins.values, [0, 0, 0, 0]
  end
end
