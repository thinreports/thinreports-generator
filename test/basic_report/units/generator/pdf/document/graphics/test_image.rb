# frozen_string_literal: true

require 'test_helper'
require 'base64'

class Thinreports::BasicReport::Generator::PDF::Graphics::TestImage < Minitest::Test
  include Thinreports::BasicReport::TestHelper

  def setup
    format = Thinreports::BasicReport::Layout::Format.build(self.layout_file.path)
    @document = Thinreports::BasicReport::Generator::PDF::Document.new.tap { |doc|
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

  def test_clean_temp_images
    @document.base64image(Base64.encode64(read_data_file('image_normal.png')), 0, 0, 100, 100)
    @document.base64image(Base64.encode64(read_data_file('image_normal.jpg')), 0, 0, 100, 100)

    assert_equal 2, @document.temp_image_registry.size

    image_file_and_paths = @document.temp_image_registry.values.map { |image| [image, image.path] }

    @document.clean_temp_images

    assert_empty @document.temp_image_registry

    image_file_and_paths.each do |file, path|
      assert_nil file.path
      refute File.exist?(path)
    end
  end

  def each_image(&block)
    %w(
      image_normal.png
      image_normal.jpg
      image_pallete_based.png
    ).each { |image_filename| block.call(image_filename) }
  end
end
