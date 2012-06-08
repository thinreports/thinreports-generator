# coding: utf-8

require 'tempfile'
require 'base64'

module ThinReports
  module Generator
    
    module PDF::Graphics
      # @param [String] filename
      # @param [Numeric, Strng] x
      # @param [Numeric, Strng] y
      # @param [Numeric, Strng] w
      # @param [Numeric, Strng] h
      def image(filename, x, y, w, h)
        w, h = s2f(w, h)
        pdf.image(filename, :at => pos(x, y), :width  => w, :height => h)
      end
      
      # @param [String] base64
      # @param [Numeric, Strng] x
      # @param [Numeric, Strng] y
      # @param [Numeric, Strng] w
      # @param [Numeric, Strng] h
      def base64image(base64, x, y, w, h)
        image = create_temp_imagefile(base64)
        image(image.path, x, y, w, h)
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
        w, h = s2f(w, h)
        pdf.bounding_box(pos(x, y), :width => w, :height => h) do
          pdf.image(file, :position  => options[:position_x] || :left,
                          :vposition => options[:position_y] || :top,
                          :auto_fit  => [w, h])
        end
      end
      
    private
      
      def clean_temp_images
        temp_image_registry.each {|tmp| tmp.unlink }
      end
      
      def temp_image_registry
        @temp_image_registry ||= []
      end
      
      # @param [String] base64
      # @return [Tempfile]
      def create_temp_imagefile(base64)
        file = Tempfile.new('trg-tmp-img')
        file.binmode
        file.write(Base64.decode64(base64))
        temp_image_registry << file
        file
      ensure
        file.close
      end      
    end
    
  end
end
