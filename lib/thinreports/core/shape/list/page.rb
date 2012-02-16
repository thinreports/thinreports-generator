# coding: utf-8

module ThinReports
  module Core::Shape
    
    class List::Page < Basic::Interface
      
      # @param [ThinReports::Core::Page] parent
      # @param [ThinReports::Core::Shape::Basic::Format] format
      # @param [ThinReports::Core::Shape::List::PageState] internal (nil)
      # @param [ThinReports::Core::Shape::List::Manager] manager (nil)
      def initialize(parent, format, internal = nil, manager = nil)
        super(parent, format, internal)
        
        @manager = if manager
          manager.switch_current!(self)
        else
          List::Manager.new(self)
        end
      end
      
      # @param [Hash] values ({})
      # @yield [header,]
      # @yieldparam [ThinReports::Core::Shape::List::SectionInterface] header
      # @return [ThinReports::Core::Shape::List::SectionInterface]
      # @raise [ThinReports::Errors::DisabledListSection]
      def header(values = {}, &block)
        manager.header(values, &block)
      end
      
      # @param [Hash] values ({})
      # @yield [row,]
      # @yieldparam [ThinReports::Core::Shape::List::SectionInterface] row
      # @return [Boolean]
      def add_row(values = {}, &block)
        manager.insert_new_detail(values, &block)
      end
      
      # If enabled, the auto-page-break of the list will force a page break
      # at the time this method is called. Otherwise, this list will be finalized.
      def page_break
        if manager.auto_page_break?
          manager.change_new_page
        else
          manager.finalize_page
        end
      end
      alias_method :finalize, :page_break
      
      # @return [Boolean] If overfilling the list to insert a detail row
      #   or already finalized, return the true. Otherwise false.
      def overflow?
        finalized? || manager.overflow_with?(:detail)
      end
      
      # @return [Boolean] Return the true,
      #   if the current page of list is already finalized.
      def finalized?
        internal.finalized?
      end
      
      # @return [ThinReports::Core::Shape::List::Configuration]
      def config
        manager.config
      end
            
      # @return [ThinReports::Core::Shape::List::Store]
      def store
        config.store
      end
      
      # @return [ThinReports::Core::Shape::List::Events]
      def events
        config.events
      end
      
      # @param [ThinReports::Core::Page] new_parent
      # @return [ThinReports::Core::Shape::List::Page]
      # @private
      def copy(new_parent)
        if manager.auto_page_break?
          new_list = self.class.new(new_parent, internal.format,
                                    nil, manager)
        else
          manager.finalize
          
          new_list = self.class.new(new_parent, internal.format,
                                    internal.copy(new_parent), manager)
          internal.rows.each do |row|
            new_list.internal.rows << row.copy(new_list)
          end
          new_list.finalized!
        end
        
        if internal.format.has_header?
          new_list.internal.header = internal.header.copy(new_list)
        end
        new_list
      end
      
      # @private
      def manager
        @manager
      end
      
    private
      
      # @see ThinReports::Core::Shape::Base::Interface#init_internal
      def init_internal(parent, format)
        List::PageState.new(parent, format)
      end
    end
    
    # Alias to List::Page.
    # @see ThinReports::Core::Shape::List::Page
    # @private
    List::Interface = List::Page
    
  end
end
