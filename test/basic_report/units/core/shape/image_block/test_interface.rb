# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::Core::Shape::ImageBlock::TestInterface < Minitest::Test
  include Thinreports::BasicReport::TestHelper

  ImageBlock = Thinreports::BasicReport::Core::Shape::ImageBlock

  def setup
    @report = Thinreports::BasicReport::Report.new layout: layout_file.path
    @page = @report.start_new_page
  end

  def test_src
    @page.item(:image_block).src('/path/to/image.png')
    assert_equal '/path/to/image.png', @page.item(:image_block).src
  end

  def test_src=
    @page.item(:image_block).src = '/path/to/image.png'
    assert_equal '/path/to/image.png', @page.item(:image_block).src
  end
end
