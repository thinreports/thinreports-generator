# frozen_string_literal: true

module Thinreports
  module Core
    module Format
      # @abstract
      class Base
        class << self
          def config_reader(*configs, &block)
            each_configs(*configs) do |m, location|
              define_read_method(m, location, &block)
            end
          end

          def config_checker(check, *configs)
            checker = ->(val) { val == check }
            each_configs(*configs) do |m, location|
              define_read_method(:"#{m}?", location, &checker)
            end
          end

          def config_writer(*configs)
            each_configs(*configs) do |m, location|
              define_write_method(m, location)
            end
          end

          def config_accessor(*configs, &block)
            config_reader(*configs, &block)
            config_writer(*configs)
          end

          private

          def define_read_method(m, location = nil, &block)
            define_method(m) do
              read(*location, &block)
            end
          end

          def define_write_method(m, location = nil)
            define_method(:"#{m}=") do |value|
              write(value, *location)
            end
          end

          def each_configs(*configs, &block)
            c = configs.first.is_a?(::Hash) ? configs.first : (configs || [])
            c.each do |m, location|
              block.call(m, location || [m.to_s])
            end
          end
        end

        def initialize(config, &block)
          @config = config
          block.call(self) if ::Kernel.block_given?
        end

        def attributes
          @config
        end

        private

        def find(*keys)
          if keys.empty?
            @config
          else
            keys.inject(@config) do |c, k|
              c.is_a?(::Hash) ? c[k] : (break c)
            end
          end
        end

        def write(value, *keys)
          key = keys.pop
          owner = find(*keys)
          owner[key] = value
        end

        def read(*keys, &block)
          value = find(*keys)
          ::Kernel.block_given? ? block.call(value) : value
        end
      end
    end
  end
end
