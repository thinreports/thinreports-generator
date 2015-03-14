# coding: utf-8

module Thinreports
  module Core
    
    # @private
    module HashExtensions
      def simple_deep_copy
        inject({}) {|h, (k, v)| h[k] = (v.dup rescue v); h}
      end
    end
    
  end
end

# @private
class Hash
  include Thinreports::Core::HashExtensions
end
