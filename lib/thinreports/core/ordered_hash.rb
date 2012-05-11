# coding: utf-8

module ThinReports
  module Core
    
    ruby_18 do
      # @private
      class OrderedHash < ::Hash
        def initialize
          @keys = []
          super
        end
        
        def []=(key, value)
          @keys << key unless member?(key)
          super
        end
        
        def each
          @keys.each {|key| yield(key, self[key])}
        end
        
        def each_key
          @keys.each {|key| yield(key)}
        end
        
        def keys
          @keys
        end
      end
    end
    
    ruby_19 do
      # @private
      OrderedHash = ::Hash
    end
    
  end
end
