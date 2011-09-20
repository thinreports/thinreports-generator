# coding: utf-8

require 'test/unit/helper'

class ThinReports::Layout::TestFormat < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  TEST_SIMPLE_FORMAT = <<-'EOF'
  {
    "version":"%s",
    "finger-print":-860627816,
    "config":{
      "title":"Sample Layout",
      "page":{
        "paper-type":"A4",
        "width":null,
        "height":null,
        "orientation":"portrait",
        "margin-top":"20",
        "margin-bottom":"20",
        "margin-left":"20",
        "margin-right":"20"
      },
      "option":{}
    },
    "svg":"<!--SHAPE{\"type\":\"s-rect\",\"id\":\"rect1\"}SHAPE-->
           <!--SHAPE{\"type\":\"s-image\",\"id\":\"image1\"}SHAPE-->
           <!--SHAPE{\"type\":\"s-tblock\",\"id\":\"tblock1\"}SHAPE-->
           <!--SHAPE{\"type\":\"s-tblock\",\"id\":\"tblock2\"}SHAPE-->"
  }
  EOF
  
  # Alias
  Shape  = ThinReports::Core::Shape
  Layout = ThinReports::Layout
  
  def test_report_title
    format = Layout::Format.new('config' => {'title' => 'Title'})
    assert_equal format.report_title, 'Title'
  end
  
  def test_user_paper_type_return_true_when_type_is_user
    format = Layout::Format.new('config' => {'page' => {'paper-type' => 'user'}})
    assert_equal format.user_paper_type?, true
  end
  
  def test_user_paper_type_return_false_when_type_is_not_user
    format = Layout::Format.new('config' => {'page' => {'paper-type' => 'A4'}})
    assert_equal format.user_paper_type?, false
  end
  
  def test_last_version
    format = Layout::Format.new('version' => '1.0')
    assert_equal format.last_version, '1.0'
  end
  
  def test_build_simple_format
    flexmock(Layout::Format).
      should_receive(:read_format_file).and_return(create_raw_format).once
    
    begin
      format = Layout::Format.build('dummy.tlf', :force => true)
    rescue => e
      flunk exception_details(e, 'Faile to build.')
    end
    
    assert_equal format.shapes.size, 4
    [:rect1, :image1, :tblock1, :tblock2].each do |shape|
      assert_includes format.shapes.keys, shape
    end
  end
  
  def test_identifier_return_the_digest_value
    flexmock(Layout::Format).
      should_receive(:read_format_file).and_return(create_raw_format).once  
    
    format = Layout::Format.build('dummy.tlf')
    expect = Digest::SHA1.hexdigest(create_raw_format)
    
    assert_equal format.identifier, expect.to_sym
  end
  
  def test_always_return_the_same_result_when_build_in_cached_mode
    flexmock(Layout::Format).
      should_receive(:read_format_file).and_return(create_raw_format).times(2)
    
    # Run building with in cached mode.
    # First time, not be cached.
    result1 = Layout::Format.build('dummy.tlf')
    
    # Later, be cached if format is same.
    result2 = Layout::Format.build('dummy.tlf')
    
    assert_same result1, result2
  end
  
  def test_build_raise_when_layout_file_is_incompatible
    original_rules = Layout::Version::REQUIRED_RULES.dup
    Layout::Version::REQUIRED_RULES.replace(['== 2.0.0'])
    
    flexmock(Layout::Format).
      should_receive(:read_format_file).and_return(create_raw_format('1.0.0'))
    
    assert_raises ThinReports::Errors::IncompatibleLayoutFormat do
      Layout::Format.build('dummy.tlf')
    end
  ensure
    Layout::Version::REQUIRED_RULES.replace(original_rules)
  end
  
  def setup
    flexmock(Shape::TextBlock::Format).
      should_receive(:build).and_return {|f| flexmock(:id => f['id']) }
    flexmock(Shape::Basic::Format).
      should_receive(:build).and_return {|f| flexmock(:id => f['id']) }
  end
  
  def create_raw_format(version = ThinReports::VERSION)
    clean_whitespaces(TEST_SIMPLE_FORMAT) % version
  end
end