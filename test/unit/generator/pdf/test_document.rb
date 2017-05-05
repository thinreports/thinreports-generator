# frozen_string_literal: true

require 'test_helper'

class Thinreports::Generator::PDF::TestDocument < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Document = Thinreports::Generator::PDF::Document

  def test_new
    pdf = Document.new
    assert_equal pdf.internal.page_count, 0
    assert_equal pdf.internal.page.margins.values, [0, 0, 0, 0]

    pdf = Document.new(security: { owner_password: 'abc' })
    assert_equal true, pdf.internal.state.encrypt

    pdf = Document.new(title: 'Title')
    assert_equal 'Title', pdf.internal.state.store.info.data[:Title]
  end
end
