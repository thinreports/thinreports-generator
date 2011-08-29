# coding: utf-8

module ThinReports
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
      
      if RUBY_VERSION < '1.9'
        def ruby_18
          yield
        end
        def ruby_19
          false
        end
      else
        def ruby_18
          false
        end
        def ruby_19
          yield
        end
      end
    end
    
  end
end

# Include global methods.
include ThinReports::Core::Utils