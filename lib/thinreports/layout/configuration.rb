# coding: utf-8

module Thinreports
  module Layout

    class Configuration
      include Core::Shape::Manager::Target

      # @param [Thinreports::Layout::Base] layout
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

      def values
        raise NoMethodError
      end
    end

  end
end
