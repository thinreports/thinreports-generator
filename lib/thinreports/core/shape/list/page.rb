# coding: utf-8

module Thinreports
  module Core::Shape
    
    class List::Page < Basic::Interface
      # @param [Thinreports::Core::Page] parent
      # @param [Thinreports::Core::Shape::Basic::Format] format
      # @param [Thinreports::Core::Shape::List::PageState] internal (nil)
      # @param [Thinreports::Core::Shape::List::Manager] manager (nil)
      def initialize(parent, format, internal = nil, manager = nil)
        super(parent, format, internal)
        
        @manager = if manager
          manager.switch_current!(self)
        else
          List::Manager.new(self)
        end

        # Set a reference to List::PageState List::Manager
        self.internal.manager = self.manager
      end
      
      # @param [Hash] values ({})
      # @yield [header,]
      # @yieldparam [Thinreports::Core::Shape::List::SectionInterface] header
      # @return [Thinreports::Core::Shape::List::SectionInterface]
      # @raise [Thinreports::Errors::DisabledListSection]
      def header(values = {}, &block)
        manager.header(values, &block)
      end
      
      # @param [Hash] values ({})
      # @yield [row,]
      # @yieldparam [Thinreports::Core::Shape::List::SectionInterface] row
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
      
      # @return [Thinreports::Core::Shape::List::Configuration]
      def config
        manager.config
      end
            
      # @return [Thinreports::Core::Shape::List::Store]
      def store
        config.store
      end
      
      # @return [Thinreports::Core::Shape::List::Events]
      def events
        config.events
      end
      
      # @param [Thinreports::Core::Page] new_parent
      # @return [Thinreports::Core::Shape::List::Page]
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
      
      # @see Thinreports::Core::Shape::Base::Interface#init_internal
      def init_internal(parent, format)
        List::PageState.new(parent, format)
      end
    end
    
    # Alias to List::Page.
    # @see Thinreports::Core::Shape::List::Page
    # @private
    List::Interface = List::Page
    
  end
end
