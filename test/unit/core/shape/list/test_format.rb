# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::List::TestFormat < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  TEST_LIST_FORMAT = {
    "type" => "s-list",
    "id" => "List",
    "display" => "true",
    "page-footer-enabled" => "true",
    "footer-enabled" => "true",
    "header-enabled" => "true",
    "page-break" => "true",
    "content-height" => 255,
    "detail" => {},
    "footer" => {},
    "page-footer" => {},
    "header" => {},
    "svg" => {
      "tag" => "g",
      "attrs" => {}
    }
  }
  
  List = ThinReports::Core::Shape::List
  
  def test_build_when_all_sections_enabled
    flexmock(List::SectionFormat).
        should_receive(:build).times(4).and_return({})
    
    begin
      format = build_format
    rescue => e
      flunk exception_details(e, 'Building failed.')
    end
    
    assert_equal format.sections.size, 4
    [:detail, :header, :footer, :page_footer].each do |sec|
      assert_includes format.sections.keys, sec
    end
  end
  
  def test_build_when_page_footer_and_footer_disabled
    flexmock(List::SectionFormat).
        should_receive(:build).times(2).and_return({})
    
    format = build_format('page-footer-enabled' => 'false',
                          'footer-enabled'      => 'false')
    
    assert_equal format.sections.size, 2
    [:detail, :header].each do |sec|
      assert_includes format.sections.keys, sec
    end
  end

  def test_config_readers
    format = List::Format.new(TEST_LIST_FORMAT)
    
    assert_equal format.height, 255
    assert_equal format.auto_page_break?, true
    assert_equal format.has_header?, true
    assert_equal format.has_footer?, true
    assert_equal format.has_page_footer?, true
  end
  
  def build_format(data = {})
    List::Format.build(TEST_LIST_FORMAT.merge(data))
  end
end
