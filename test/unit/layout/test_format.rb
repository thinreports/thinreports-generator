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
           <!--SHAPE{\"type\":\"s-tblock\",\"id\":\"tblock2\"}SHAPE-->",
    "state":{
      "layout-guides": [{"type":"x", "position":100}]
    }
  }
  EOF
  
  # Alias
  Shape  = ThinReports::Core::Shape
  Layout = ThinReports::Layout
  
  def test_report_title_should_return_the_value_of_config_title_key
    format = Layout::Format.new('config' => {'title' => 'Title'})
    assert_equal format.report_title, 'Title'
  end
  
  def test_user_paper_type_asker_should_return_true_when_paper_type_is_user
    format = Layout::Format.new('config' => {'page' => {'paper-type' => 'user'}})
    assert_equal format.user_paper_type?, true
  end
  
  def test_user_paper_type_asker_should_return_false_when_paper_type_is_not_user
    format = Layout::Format.new('config' => {'page' => {'paper-type' => 'A4'}})
    assert_equal format.user_paper_type?, false
  end
  
  def test_last_version_should_return_the_value_of_version_key
    format = Layout::Format.new('version' => '1.0')
    assert_equal format.last_version, '1.0'
  end
  
  def test_build_should_properly_build_layout_format
    build_format(:force => true)
  rescue => e
    flunk exception_details(e, 'Faile to build.')
  end
  
  def test_build_should_properly_set_built_shapes_to_shapes_attributes_of_format
    assert_equal build_format.shapes.size, 4
  end
  
  def test_config_attributes_of_built_format_should_not_have_unnecessary_attributes
    format = build_format(:force => true)
    config = format.instance_variable_get(:@config)
    
    refute %w( version finger-print state).any? {|a| config.key?(a)},
           'A config attributes of built format have unnecessary attributes.'
  end
  
  def test_identifier_should_return_the_digest_value_of_the_raw_layout_using_sha1
    format = build_format
    expect = Digest::SHA1.hexdigest(create_raw_format)
    
    assert_equal format.identifier, expect.to_sym
  ensure
    clear_building_cache
  end
  
  def test_build_should_always_return_the_same_result_in_cache_mode
    result1 = build_format
    result2 = build_format
    
    assert_same result1, result2
  ensure
    clear_building_cache
  end
  
  def test_build_should_raise_when_layout_file_is_incompatible
    original_rules = Layout::Version::REQUIRED_RULES.dup
    Layout::Version::REQUIRED_RULES.replace(['>= 0.6.0.pre3', '< 0.8.0'])
    
    assert_raises ThinReports::Errors::IncompatibleLayoutFormat do
      build_format(:version => '0.6.0.pre2')
    end
  ensure
    Layout::Version::REQUIRED_RULES.replace(original_rules)
    clear_building_cache
  end
  
  def create_raw_format(version = nil)
    clean_whitespaces(TEST_SIMPLE_FORMAT) % (version || ThinReports::VERSION)
  end
  
  def build_format(options = {})
    flexmock(Layout::Format).
      should_receive(:read_format_file).
      and_return(create_raw_format(options[:version]))
    
    Layout::Format.build('dummy.tlf', :force => options[:force])
  end
  
  def clear_building_cache
    Layout::Format.send(:built_format_registry).clear
  end
end