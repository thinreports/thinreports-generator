# frozen_string_literal: true

module Thinreports
  module Errors
    class Basic < ::StandardError
    end

    class UnknownShapeStyleName < Basic
      def initialize(style, availables)
        super("The specified style name, '#{style}', cannot be used. " \
              "The available styles are #{availables.map { |s| ":#{s}" }.join(', ')}.")
      end
    end

    class UnknownSectionId < Basic
      def initialize(section_type, section_id)
        super(":#{section_id} is not defined in #{section_type}")
      end
    end

    class UnknownShapeType < Basic
    end

    class UnknownFormatterType < Basic
    end

    class LayoutFileNotFound < Basic
    end

    class FontFileNotFound < Basic
    end

    class NoRegisteredLayoutFound < Basic
    end

    class UnknownItemId < Basic
      def initialize(id, item_type = 'Basic')
        super("The layout does not have a #{item_type} Item with id '#{id}'.")
      end
    end

    class DisabledListSection < Basic
      def initialize(section)
        super("The #{section} section is disabled.")
      end
    end

    class UnknownLayoutId < Basic
    end

    class UnsupportedColorName < Basic
    end

    class InvalidLayoutFormat < Basic
    end

    class IncompatibleLayoutFormat < Basic
      def initialize(filename, fileversion, required_rules)
        super("Generator #{Thinreports::VERSION} can not be built this file, " \
              "'#{File.basename(filename)}'. " \
              "This file is updated in the Editor of version '#{fileversion}', " \
              "but Generator requires version #{required_rules}.")
      end
    end
  end
end
