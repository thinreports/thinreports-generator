# coding: utf-8

module ThinReports
  module Core
    
    module Shape
      # @private
      def Interface(parent, format)
        find_by_type(format.type)::Interface.new(parent, format)
      end
      
      # @private
      def Format(type)
        find_by_type(type)::Format
      end
      
      # @private
      def Configuration(type)
        klass = find_by_type(type)
        unless klass.const_defined?(:Configuration)
          raise ThinReports::Errors::NoConfigurationFound, type
        end
        klass.const_get(:Configuration)
      end
      
      module_function :Interface, :Format, :Configuration
      
      # @private
      def self.find_by_type(type)
        case type
        when Tblock::TYPE_NAME
          Tblock
        when List::TYPE_NAME
          List
        when Text::TYPE_NAME
          Text
        when *Basic::TYPE_NAMES
          Basic
        else
          raise ThinReports::Errors::UnknownShapeType
        end
      end
    end
  
  end
end

require 'thinreports/core/shape/manager'
require 'thinreports/core/shape/base'
require 'thinreports/core/shape/basic'
require 'thinreports/core/shape/text'
require 'thinreports/core/shape/tblock'
require 'thinreports/core/shape/list'
