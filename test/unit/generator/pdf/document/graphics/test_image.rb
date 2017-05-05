# frozen_string_literal: true

require 'test_helper'
require 'base64'

class Thinreports::Generator::PDF::Graphics::TestImage < Minitest::Test
  include Thinreports::TestHelper

  def setup
    format = Thinreports::Layout::Format.build(self.layout_file.path)
    @document = Thinreports::Generator::PDF::Document.new.tap { |doc|
      doc.start_new_page(format)
    }
  end

  def test_image
    each_image do |image_filename|
      @document.image(data_file(image_filename), 0, 0, 100, 100)
      @document.image(StringIO.new(read_data_file(image_filename)), 0, 100, 100, 100)
    end
    assert_equal 6, analyze_pdf_images(@document.render).count
  end

  def test_base64image
    each_image do |image_filename|
      @document.base64image(Base64.encode64(read_data_file(image_filename)), 0, 0, 100, 100)
    end
    assert_equal 3, analyze_pdf_images(@document.render).count
  end

  def test_image_box
    each_image do |image_filename|
      @document.image_box(data_file(image_filename), 0, 0, 100, 100)
      @document.image(StringIO.new(read_data_file(image_filename)), 0, 100, 100, 100)
    end
    assert_equal 6, analyze_pdf_images(@document.render).count
  end

  def each_image(&block)
    %w(
      image_normal.png
      image_normal.jpg
      image_pallete_based.png
    ).each { |image_filename| block.call(image_filename) }
  end
end
