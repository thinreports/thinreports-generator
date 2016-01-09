# coding: utf-8

require 'tempfile'
require 'base64'
require 'digest/md5'
require 'chunky_png'

module Thinreports
  module Generator

    module PDF::Graphics
      # @param [String] filename
      # @param [Numeric, Strng] x
      # @param [Numeric, Strng] y
      # @param [Numeric, Strng] w
      # @param [Numeric, Strng] h
      def image(filename, x, y, w, h)
        w, h = s2f(w, h)
        pdf.image(filename, at: pos(x, y), width: w, height: h)
      end

      # @param [String] image_type Mime-type of image
      # @param [String] base64
      # @param [Numeric, Strng] x
      # @param [Numeric, Strng] y
      # @param [Numeric, Strng] w
      # @param [Numeric, Strng] h
      def base64image(image_type, base64_data, x, y, w, h)
        image_path = normalize_image_from_base64(image_type, base64_data)
        image(image_path, x, y, w, h)
      end

      # @param file (see Prawn#image)
      # @param [Numeric, Strng] x
      # @param [Numeric, Strng] y
      # @param [Numeric, Strng] w
      # @param [Numeric, Strng] h
      # @param [Hash] options
      # @option options [:left, :center, :right] :position_x (:left)
      # @option options [:top, :center, :bottom] :position_y (:top)
      def image_box(file, x, y, w, h, options = {})
        image_path = normalize_image_from_file(file)

        w, h = s2f(w, h)
        pdf.bounding_box(pos(x, y), width: w, height: h) do
          pdf.image(image_path, position: options[:position_x] || :left,
                                vposition: options[:position_y] || :top,
                                auto_fit: [w, h])
        end
      end

      def normalize_image_from_base64(image_type, base64_string)
        raw_image_data = Base64.decode64(base64_string)

        image_data = if png_conversion_enabled? && image_type == 'image/png'
          png_normalizer = PNGNormalizer.load_blob(raw_image_data)

          if png_normalizer.need_normalize?
            png_normalizer.normalize
          else
            raw_image_data
          end
        else
          raw_image_data
        end

        image_id = Digest::MD5.hexdigest(base64_string)
        create_temp_imagefile(image_id, image_data)
      end

      def normalize_image_from_file(filename)
        extname = File.extname(filename)

        return filename unless png_conversion_enabled?
        return filename unless extname.downcase == '.png' || extname.empty?

        return temp_image_registry[filename] if temp_image_registry.key?(filename)

        png_normalizer = PNGNormalizer.load_file(filename)

        # Returns the original filename when the image is not PNG.
        return filename if png_normalizer.nil?
        return filename unless png_normalizer.need_normalize?

        image_id = filename
        image_data = png_normalizer.normalize

        create_temp_imagefile(image_id, image_data)
      end

      def clean_temp_images
        temp_image_registry.each_value do |image_path|
          File.delete(image_path) if File.exists?(image_path)
        end
      end

      def temp_image_registry
        @temp_image_registry ||= {}
      end

      # @param [String] image_id
      # @param [String] image_data
      # @return [String] imagefile path
      def create_temp_imagefile(image_id, image_data)
        temp_image_registry[image_id] ||= begin
          file = Tempfile.new('temp-image')
          file.binmode
          file.write(image_data)
          file.path
        ensure
          file.close
        end
        temp_image_registry[image_id]
      end

      def png_conversion_enabled?
        Thinreports.config.convert_palleted_transparency_png
      end

      class PNGNormalizer
        def self.load_file(filename)
          image = ChunkyPNG::Image.from_file(filename)
          datastream = ChunkyPNG::Datastream.from_file(filename)
          self.new image, datastream
        rescue ChunkyPNG::SignatureMismatch
          # Returns nil if image is not PNG.
          nil
        end

        def self.load_blob(data)
          image = ChunkyPNG::Image.from_blob(data)
          datastream = ChunkyPNG::Datastream.from_blob(data)
          self.new image, datastream
        rescue ChunkyPNG::SignatureMismatch
          # Returns nil if image is not PNG.
          nil
        end

        def initialize(image, datastream)
          @image = image
          @datastream = datastream
        end

        def need_normalize?
          pallete_based? && transparency_chunk?
        end

        def normalize
          @image.to_blob(color_mode: ChunkyPNG::COLOR_TRUECOLOR_ALPHA)
        end

        private

        def pallete_based?
          color_mode, _depth = @image.palette.best_color_settings
          color_mode == ChunkyPNG::COLOR_INDEXED
        end

        def transparency_chunk?
          !@datastream.transparency_chunk.nil?
        end
      end
    end

  end
end
