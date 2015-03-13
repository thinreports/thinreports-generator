# coding: utf-8

require 'test_helper'

class ThinReports::Core::Shape::ImageBlock::TestInterface < Minitest::Test
  include ThinReports::TestHelper

  ImageBlock = ThinReports::Core::Shape::ImageBlock

  def setup
    report = ThinReports::Report.new layout: data_file('layout_text1')
    parent = report.start_new_page

    @interface = ImageBlock::Interface.new parent, ImageBlock::Format.new({})
  end

  def test_src_should_work_the_same_as_value_method
    @interface.src('/path/to/image.png')
    assert_equal @interface.src, '/path/to/image.png'
  end

  def test_properly_initialized_internal_property
    assert_instance_of ImageBlock::Internal, @interface.internal
  end
end
