# coding: utf-8

module ThinReports
  
  module Errors
    class Basic < ::StandardError
    end
    
    class UnknownShapeStyleName < Basic
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
    end
    
    class DisabledListSection < Basic
    end
    
    class UnknownEventType < Basic
    end
    
    class UnknownLayoutId < Basic
    end
    
    class UnknownGeneratorType < Basic
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
              "This file is created in the Editor of version '#{fileversion}', " +
              "but Generator requires version #{required_rules}.")
      end      
    end
  end
    
end
