# coding: utf-8

require 'test_helper'

require 'base64'
require 'digest/md5'

class Thinreports::Generator::PDF::Graphics::TestImage < Minitest::Test
  include Thinreports::TestHelper

  class TestImage
    include Thinreports::Generator::PDF::Graphics
  end

  def test_normalize_image_from_base64_with_normal_images
    [
      ['image/png',  'image_normal.png'],
      ['image/jpeg', 'image_normal.jpg']
    ]
    .each do |(image_type, image_file)|
      base64_normal_image = Base64.encode64(read_data_file(image_file))

      test_image = TestImage.new

      normalized_image_path = test_image.normalize_image_from_base64(image_type, base64_normal_image)

      image_registry = test_image.temp_image_registry
      assert_equal 1, image_registry.count

      image_id = Digest::MD5.hexdigest(base64_normal_image)
      assert_includes image_registry.keys, image_id
      assert_equal normalized_image_path, image_registry[image_id]

      assert equal_image(data_file(image_file), normalized_image_path)

      assert_same normalized_image_path,
        test_image.normalize_image_from_base64(image_type, base64_normal_image)
    end
  end

  def test_normalize_image_from_base64_with_palette_transparency_png
    base64_palleted_png = Base64.encode64(read_data_file('image_pallete_based.png'))

    test_image = TestImage.new

    normalized_image_path = test_image.normalize_image_from_base64('image/png', base64_palleted_png)

    image_registry = test_image.temp_image_registry
    assert_equal 1, image_registry.count

    image_id = Digest::MD5.hexdigest(base64_palleted_png)
    assert_includes image_registry.keys, image_id
    assert_equal normalized_image_path, image_registry[image_id]

    refute equal_image(data_file('image_pallete_based.png'), normalized_image_path)

    assert_not_palette_based_transparency_png(normalized_image_path)

    # 2nd time
    assert_same normalized_image_path,
      test_image.normalize_image_from_base64('image/png', base64_palleted_png)
    assert_equal 1, test_image.temp_image_registry.count
  end

  def test_normalize_image_from_file_with_normal_images
    [
      data_file('image_normal.png'),
      data_file('iamge_normal.jpg')
    ]
    .each do |original_image_path|
      test_image = TestImage.new
      image_path = test_image.normalize_image_from_file(original_image_path)

      assert_equal original_image_path, image_path
      assert_empty test_image.temp_image_registry
    end
  end

  def test_normalize_image_from_file_with_palette_transparency_png
    original_image_path = data_file('image_pallete_based.png')

    test_image = TestImage.new

    normalized_image_path = test_image.normalize_image_from_file(original_image_path)
    image_registry = test_image.temp_image_registry

    assert_equal 1, image_registry.count
    assert_includes image_registry.keys, original_image_path

    refute equal_image(original_image_path, normalized_image_path)

    assert_not_palette_based_transparency_png(normalized_image_path)
  end

  def assert_not_palette_based_transparency_png(image_path)
    image_data = ChunkyPNG::Image.from_file(image_path)
    datastream = ChunkyPNG::Datastream.from_file(image_path)

    assert_equal ChunkyPNG::COLOR_INDEXED, image_data.palette.best_color_settings.first
    assert_equal nil, datastream.transparency_chunk
  end

  def equal_image(expect_path, actual_path)
    expect_image = File.binread(expect_path)
    actual_image = File.binread(actual_path)
    expect_image == actual_image
  end
end
