# coding: utf-8

require 'test_helper'

class Thinreports::Core::Format::TestBuilder < Minitest::Test
  include Thinreports::TestHelper

  TEST_RAW_FORMAT = <<-'EOS'
    {
      "node1": "あ漢字＠㈱Ⅰカナｶﾅ",
      "node2": { "node2_child":"node2_child value" },
      "layout":
        "<svg width=\"595.2\" height=\"841.8\">
           <g class=\"canvas\">
             <rect x=\"100\" y=\"100\" width=\"100\" height=\"100\" fill=\"red\" x-attr=\"cleaned attr\"></rect>
             <!--SHAPE{\"type\":\"s-tblock\",\"id\":\"t1\",\"attrs\":{\"x\":58,\"y\":103.6}}SHAPE-->
             <!--LAYOUT<text x=\"60\" y=\"103\">t1</text>LAYOUT-->
           </g>
         </svg>"
    }
  EOS

  class TestFormat < Thinreports::Core::Format::Base
    extend ::Thinreports::Core::Format::Builder
    config_reader :layout
    config_accessor :shapes
  end

  def setup
    @raw_format = clean_whitespaces(TEST_RAW_FORMAT)
  end

  def test_parse_json
    expected_format = {
      "node1" => "あ漢字＠㈱Ⅰカナｶﾅ",
      "node2" => {
        "node2_child" => "node2_child value"
      },
      "layout" => clean_whitespaces(<<-EOS)
        <svg width=\"595.2\" height=\"841.8\">
          <g class=\"canvas\">
            <rect x=\"100\" y=\"100\" width=\"100\" height=\"100\" fill=\"red\" x-attr=\"cleaned attr\"></rect>
            <!--SHAPE{\"type\":\"s-tblock\",\"id\":\"t1\",\"attrs\":{\"x\":58,\"y\":103.6}}SHAPE-->
            <!--LAYOUT<text x=\"60\" y=\"103\">t1</text>LAYOUT-->
          </g>
        </svg>
      EOS
    }
    assert_equal TestFormat.parse_json(@raw_format), expected_format
  end

  def test_build_layout
    format = TestFormat.new(TestFormat.parse_json(@raw_format))
    format.shapes = {}

    TestFormat.build_layout(format) do |type, f|
      Thinreports::Core::Shape::Format(type).build(f)
    end

    assert_equal format.layout, clean_whitespaces(<<-'EOS')
      <svg width="595.2" height="841.8">
        <g class="canvas">
          <rect x="100" y="100" width="100" height="100" fill="red" x-attr="cleaned attr"></rect>
          <!--LAYOUT<text x="60" y="103">t1</text>LAYOUT-->
        </g>
      </svg>
    EOS
    assert_includes format.shapes.keys, :t1
  end

  def test_clean
    source = clean_whitespaces(<<-'EOS')
      <svg width="595.2" height="841.8">
        <rect x="100" y="100" width="100" height="100" fill="red"></rect>
        <!--LAYOUT<text x="60" y="103">t1</text>LAYOUT-->
        <!---LAYOUT<text x="60" y="103">t1</text>LAYOUT--->
      </svg>
    EOS
    TestFormat.clean(source)

    assert_equal source, clean_whitespaces(<<-'EOS')
      <svg width="595.2" height="841.8">
        <rect x="100" y="100" width="100" height="100" fill="red"></rect>
      </svg>
    EOS
  end

  def test_clean_with_attributes
    source = clean_whitespaces(<<-'EOS')
      <svg width="595.2" height="841.8">
        <!--LAYOUT<text x="60" y="103">t1</text>LAYOUT-->
        <rect x="100" y="100" x-hoge="hoge" width="100" class="foo"></rect>
        <!---LAYOUT<text x="60" y="103">t1</text>LAYOUT--->
      </svg>
    EOS
    TestFormat.clean_with_attributes(source)

    assert_equal source, clean_whitespaces(<<-'EOS')
      <svg width="595.2" height="841.8">
        <rect x="100" y="100" width="100"></rect>
      </svg>
    EOS
  end

  def test_shape_tag
    shape_format = stub(id: :foo)
    assert_equal TestFormat.shape_tag(shape_format), '<%= r(:"foo")%>'
  end
end
