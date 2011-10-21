# coding: utf-8

module ThinReports
  
  module Errors
    class Basic < ::StandardError
    end
    
    class UnknownShapeStyleName < Basic
      def initialize(style, availables)
        super("The specified style name, '#{style}', cannot be used. " +
              "The available styles are #{availables.map{|s| ":#{s}"}.join(', ')}.")
      end
    end
    
    class UnknownShapeType < Basic
    end
    
    class UnknownFormatterType < Basic
    end
    
    class LayoutFileNotFound < Basic
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
    
    class UnknownEventType < Basic
    end
    
    class UnknownLayoutId < Basic
    end
    
    class UnknownGeneratorType < Basic
      def initialize(type)
        super("The specified generator type, '#{type}', was not found.")
      end
    end
    
    class NoConfigurationFound < Basic
    end
    
    class UnsupportedColorName < Basic
    end
    
    class InvalidLayoutFormat < Basic
    end
    
    class IncompatibleLayoutFormat < Basic
      def initialize(filename, fileversion, required_rules)
        super("Generator #{ThinReports::VERSION} can not be built this file, " +
              "'#{File.basename(filename)}'." +
              "This file is updated in the Editor of version '#{fileversion}', " +
              "but Generator requires version #{required_rules}.")
      end      
    end
  end
    
end
