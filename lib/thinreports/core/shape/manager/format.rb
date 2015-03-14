# coding: utf-8

module Thinreports
  module Core::Shape

    # @private
    class Manager::Format < Core::Format::Base
      # @return [Symbol, Integer]
      attr_reader :identifier

      config_reader layout: %w( svg )

      def initialize(config, id = nil, &block)
        super(config, &block)
        @identifier = id || self.object_id
      end

      def find_shape(id)
        shapes[id]
      end

      def shapes
        @shapes ||= {}
      end
    end

  end
end
