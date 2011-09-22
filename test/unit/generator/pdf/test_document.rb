# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::PDF::TestDocument < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Document = ThinReports::Generator::PDF::Document
  
  def test_new_without_page_creation
    pdf = Document.new
    assert_equal pdf.internal.page_count, 0
  end
  
  def test_new_with_zero_margin_canvas
    pdf = Document.new
    assert_equal pdf.internal.page.margins.values, [0, 0, 0, 0]
  end
  
  def test_new_with_security_settings
    flexmock(Prawn::Document).new_instances.
      should_receive(:encrypt_document).once.
      with(:user_password => 'foo')
    
    Document.new(:security => {:user_password => 'foo'})
  end
end