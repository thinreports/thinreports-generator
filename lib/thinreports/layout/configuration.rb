# coding: utf-8

module ThinReports
  module Layout
    
    class Configuration
      include Core::Shape::Manager::Target
      
      undef_method :items, :values
      
      # @param [ThinReports::Layout::Base] layout
      def initialize(layout)
        initialize_manager(layout.format) do |f|
          Core::Shape::Configuration(f.type).new
        end
      end
      
      # @param [String, Symbol] shape_id
      # @return [Object, nil]
      # @private
      def activate(shape_id)
        (config = manager.shapes[shape_id.to_sym]) && config.copy
      end
    end
    
  end
end
