# coding: utf-8

module ThinReports
  module Core
    
    # @private
    module ArrayExtensions
      def simple_deep_copy
        map {|v| v.dup rescue v }
      end
    end
    
  end
end

# @private
class Array
  include ThinReports::Core::ArrayExtensions
end
