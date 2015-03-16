# coding: utf-8

require 'test_helper'

class Thinreports::Generator::TestPDF < Minitest::Test
  include Thinreports::TestHelper

  PDF = Thinreports::Generator::PDF

  def test_new_should_set_title_as_metadata
    report = new_report('layout_text1.tlf') {|r| r.start_new_page }

    actual_pdf_title = nil
    PDF::Document.define_singleton_method(:new) {|options, meta|
      actual_pdf_title = meta[:Title]
    }
    PDF.new report, {}

    assert_equal 'Basic Layout', actual_pdf_title
  ensure
    PDF::Document.singleton_class.send(:remove_method, :new)
  end
end
