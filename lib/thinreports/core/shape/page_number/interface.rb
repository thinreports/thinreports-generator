module Thinreports
  module Core::Shape

    class PageNumber::Interface < Basic::Interface
      internal_delegators :reset_format

      def format(*args)
        if args.empty?
          internal.read_format
        else
          internal.write_format(args.first)
          self
        end
      end

    private

      # @see Thinreports::Core::Shape::Base::Interface#init_internal
      def init_internal(parent, format)
        PageNumber::Internal.new(parent, format)
      end
    end

  end
end
