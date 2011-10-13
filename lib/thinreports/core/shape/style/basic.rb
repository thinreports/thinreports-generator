# coding: utf-8

module ThinReports
  module Core::Shape
    
    class Style::Basic < Style::Base
      style_accessible :visible
      attr_accessor :visible
      
      def initialize(*args)
        super
        @visible = @format.display?
      end
    end
    
  end
end