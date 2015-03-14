# coding: utf-8

require 'test_helper'

class Thinreports::Layout::TestBase < Minitest::Test
  include Thinreports::TestHelper

  Layout = Thinreports::Layout

  def test_load_format
    assert_instance_of Layout::Format,
                       Layout::Base.load_format(data_file('layout_text1.tlf'))
    assert_instance_of Layout::Format,
                       Layout::Base.load_format(data_file('layout_text1'))

    assert_raises Thinreports::Errors::LayoutFileNotFound do
      Layout::Base.load_format 'unknown.tlf'
    end
  end

  def test_new
    layout = create_layout id: 'foo'

    assert_equal 'foo', layout.id
    assert_equal data_file('layout_text1.tlf'), layout.filename
  end

  def test_default?
    assert_equal false, create_layout(id: 'foo').default?
    assert_equal true, create_layout.default?
  end

  def test_config
    assert_instance_of Thinreports::Layout::Configuration,
                       create_layout.config
  end

  def test_new_page
    report = new_report 'layout_text1'
    assert_instance_of Thinreports::Core::Page,
                       create_layout.new_page(report)
  end

  def create_layout(options = {})
    Layout::Base.new data_file('layout_text1.tlf'), options
  end
end
