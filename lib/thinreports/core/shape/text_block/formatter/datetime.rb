# coding: utf-8

module Thinreports
  module Core::Shape::TextBlock

    # @private
    class Formatter::Datetime < Formatter::Basic

    private

      def apply_format_to(value)
        value.strftime(format.format_datetime_format)
      end

      def applicable?(value)
        !blank_value?(format.format_datetime_format) && value.respond_to?(:strftime)
      end
    end

  end
end
