# frozen_string_literal: true

require 'tempfile'
require 'base64'
require 'digest/md5'

module Thinreports
  module Generator
    class PDF
      module Graphics
        # @param [String, IO] filename_or_io
        # @param [Numeric, Strng] x
        # @param [Numeric, Strng] y
        # @param [Numeric, Strng] w
        # @param [Numeric, Strng] h
        def image(filename_or_io, x, y, w, h)
          w, h = s2f(w, h)
          pdf.image(filename_or_io, at: pos(x, y), width: w, height: h)
        end

        # @param [String] base64_data
        # @param [Numeric, Strng] x
        # @param [Numeric, Strng] y
        # @param [Numeric, Strng] w
        # @param [Numeric, Strng] h
        def base64image(base64_data, x, y, w, h)
          image_data = Base64.decode64(base64_data)
          image_id = Digest::MD5.hexdigest(base64_data)
          image_path = create_temp_imagefile(image_id, image_data)

          image(image_path, x, y, w, h)
        end

        # @param [String, IO] filename_or_io
        # @param [Numeric, Strng] x
        # @param [Numeric, Strng] y
        # @param [Numeric, Strng] w
        # @param [Numeric, Strng] h
        # @param [Hash] options
        # @option options [:left, :center, :right] :position_x (:left)
        # @option options [:top, :center, :bottom] :position_y (:top)
        # @option options [Numeric] :offset_x
        # @option options [Numeric] :offset_y
        def image_box(filename_or_io, x, y, w, h, options = {})
          w, h = s2f(w, h)

          computed_position = pos(
            x + (options[:offset_x] || 0),
            y + (options[:offset_y] || 0)
          )
          pdf.bounding_box(computed_position, width: w, height: h) do
            pdf.image(
              filename_or_io,
              position: options[:position_x] || :left,
              vposition: options[:position_y] || :top,
              auto_fit: [w, h]
            )
          end
        end

        def image_dimensions(filename_or_io, x, y, w, h, options = {})
          w, h = s2f(w, h)
          # XXX: Calling @private method
          _pdf_obj, info = pdf.build_image_object(filename_or_io)
          info.calc_image_dimensions(
            position: options[:position_x] || :left,
            vposition: options[:position_y] || :top,
            auto_fit: [w, h]
          )
        end

        def clean_temp_images
          temp_image_registry.each_value do |image_path|
            File.delete(image_path) if File.exist?(image_path)
          end
        end

        def temp_image_registry
          @temp_image_registry ||= {}
        end

        # @param [String] image_id
        # @param [String] image_data
        # @return [String] Path to imagefile
        def create_temp_imagefile(image_id, image_data)
          temp_image_registry[image_id] ||= begin
            file = Tempfile.new('temp-image')
            file.binmode
            file.write(image_data)
            file.open
            file
          end
          temp_image_registry[image_id].path
        end
      end
    end
  end
end
