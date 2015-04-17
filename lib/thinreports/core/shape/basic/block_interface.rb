# coding: utf-8

module Thinreports
  module Core::Shape

    class Basic::BlockInterface < Basic::Interface
      # @overload value(val)
      #   Set a val
      #   @param [Object] val
      #   @return [self]
      # @overload value
      #   Return the value
      #   @return [Object]
      def value(*args)
        if args.empty?
          internal.read_value
        else
          internal.write_value(args.first)
          self
        end
      end

      # @param [Object] val
      def value=(val)
        value(val)
      end
    end

  end
end
