# coding: utf-8

module ThinReports
  module Core
    
    # @private
    module ObjectExtensions
      unless ::Object.method_defined?(:blank?)
        def blank?
          case self
          when String   then self.nil? || self.empty?
          when NilClass then true
          else false
          end
        end
      end
    end
    
  end
end

# @private
class Object
  include ThinReports::Core::ObjectExtensions
end