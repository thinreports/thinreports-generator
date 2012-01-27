# coding: utf-8

module ThinReports
  module Core::Shape
    
    module Manager::Target
      # @private
      attr_reader :manager
      
      # @example
      #   item(:title).value('Title').style(:fill, 'red')
      #
      #   item(:title) do
      #     value('Title')
      #     style(:fill, 'red')
      #   end
      #   
      #   item(:title) do |t|
      #     t.value('Title')
      #     t.style(:fill, 'red')
      #   end
      # @param [String, Symbol] id
      # @yield [item,]
      # @yieldparam [ThinReports::Core::Shape::Base::Interface] item
      # @raise [ThinReports::Errors::UnknownItemId] If not found
      # @return [ThinReports::Core::Shape::Base::Interface]
      def item(id, &block)
        shape = find_item(id, :except => Core::Shape::List::TYPE_NAME)
        
        unless shape
          raise ThinReports::Errors::UnknownItemId.new(id)
        else
          block_exec_on(shape, &block)
        end
      end
      
      # @param [Hash] item_values :id => value
      def values(item_values)
        item_values.each {|id, val| item(id).value(val)}
      end
      
      # @deprecated Please use the #values method instead.
      # @see #values
      def items(*args)
        warn '[DEPRECATION] The #items method is deprecated. ' +
             'Please use the #values method instead.'
        values(*args)
      end
      
      # @param [Symbol, String] id
      # @return [Boolean]
      def item_exists?(id)
        !!manager.find_format(id)
      end
      alias_method :exists?, :item_exists?
      
      # @see #item
      def list(id = nil, &block)
        shape = find_item(id ||= :default, :only => Core::Shape::List::TYPE_NAME)

        unless shape
          raise ThinReports::Errors::UnknownItemId.new(id, 'List')
        else
          manager.lists[id.to_sym] ||= shape
          block_exec_on(shape, &block)
        end
      end

    private
      
      # @param format (see ThinReports::Core::Shape::Manager::Internal#initialize)
      # @yield [format] Handler for initialize item.
      # @yieldparam [ThinReports::Core::Shape::Basic::Format] format
      def initialize_manager(format, &block)
        @manager = Manager::Internal.new(format, block)
      end
      
      # @see ThinReports::Core::Shape::Manager::Internal#find_item
      def find_item(id, limit = {})
        manager.find_item(id, limit)
      end
    end
    
  end
end