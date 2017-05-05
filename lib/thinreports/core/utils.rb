# frozen_string_literal: true

module Thinreports
  module Utils
    def self.included(klass)
      klass.extend self
    end

    # rubocop:disable Style/RescueModifier
    def deep_copy(src)
      case src
      when Hash
        src.each_with_object({}) { |(k, v), h| h[k] = v.dup rescue v }
      when Array
        src.map { |a| a.dup rescue a }
      else
        raise ArgumentError
      end
    end

    def blank_value?(value)
      case value
      when String   then value.empty?
      when NilClass then true
      else false
      end
    end

    def call_block_in(scope, &block)
      return scope unless block_given?

      if block.arity == 1
        block.call(scope)
      else
        scope.instance_eval(&block)
      end
      scope
    end
  end

  extend Utils
end
