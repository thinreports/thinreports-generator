# coding: utf-8

module Thinreports
  module Core::Shape::TextBlock

    # @private
    class Formatter::Padding < Formatter::Basic

      private

      def apply_format_to(value)
        value.to_s.send(format.format_padding_rdir? ? :ljust : :rjust,
                        format.format_padding_length,
                        format.format_padding_char)
      end

      def applicable?(value)
        !format.format_padding_char.blank? && format.format_padding_length > 0
      end
    end

  end
end
