# coding: utf-8

module ThinReports
  module Report
    
    class Events < Core::Events
      def initialize
        super(:page_create,
              :generate)
      end
      
      class Event < ThinReports::Core::Events::Event
        # @return [ThinReports::Core::Page, nil]
        attr_reader :page
        
        # @return [Array<ThinReports::Core::Page>]
        attr_reader :pages
        
        # @return [ThinReports::Report::Base]
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
