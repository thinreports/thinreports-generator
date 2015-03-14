# coding: utf-8

module Thinreports
  module Core

    # @private
    module Utils
      def block_exec_on(context, &block)
        return context unless block_given?

        if block.arity == 1
          block.call(context)
        else
          context.instance_eval(&block)
        end
        context
      end
    end

  end
end

# Include global methods.
include Thinreports::Core::Utils
