# coding: utf-8

module Thinreports
  module Report
    
    class Events < Core::Events
      def initialize
        super(:page_create,
              :generate)
      end
      
      class Event < Thinreports::Core::Events::Event
        # @return [Thinreports::Core::Page, nil]
        attr_reader :page
        
        # @return [Array<Thinreports::Core::Page>]
        attr_reader :pages
        
        # @return [Thinreports::Report::Base]
        alias_method :report, :target
        
        def initialize(type, target, page = nil, pages = nil)
          super(type, target)

          @page  = page
          @pages = pages
        end
      end
    end
    
  end
end
