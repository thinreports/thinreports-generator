# coding: utf-8

module Thinreports
  module Generator

    class PDF::Configuration
      # @return [Array]
      attr_reader :eudc_fonts

      def initialize
        @eudc_fonts = []
      end

      # @param [String, Array<String>] fonts
      # @deprecated
      #   `Configuration#eudc_font` will be removed in the next major version.
      #   Please use `Thinreports.config.fallback_fonts=` instead.
      def eudc_fonts=(fonts)
        warn '[DEPRECATION] `eudc_fonts=` is deprecated and will be removed in ' +
             'the next major version of thinreports. ' +
             'Please use `Thinreports.config.fallback_fonts=` instead.'

        fonts = [fonts] unless fonts.is_a?(::Array)

        fonts.each do |f|
          unless File.extname(f.to_s) == '.ttf'
            raise ArgumentError, 'The EUDC Fonts can specify only the TTF file.'
          end
        end
        @eudc_fonts = fonts
      end
    end

  end
end
