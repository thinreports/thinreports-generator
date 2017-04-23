module Thinreports
  module Generator
    module PrawnExt
      module CalcImageDimensions
        # Implement :auto_fit option for image size calculation.
        #
        # When the image is larger than the box, the original: fit option does not change
        # the image size. The :auto_fit option changes the image size to fit in the box
        # while maintaining the aspect ratio.
        #
        # Usage:
        #   image '/path/to/image.png', at: [100, 100], auto_fit: [100, 100]
        #
        def calc_image_dimensions(options)
          if options[:auto_fit]
            w = options[:width] || width
            h = options[:height] || height

            box_width, box_height = options.delete(:auto_fit)

            if w > box_width || h > box_height
              options[:fit] = [box_width, box_height]
            end
          end
          super(options)
        end
      end
    end
  end
end

Prawn::Images::Image.prepend Thinreports::Generator::PrawnExt::CalcImageDimensions
