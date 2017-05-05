# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Style
        class Base
          include Utils

          class << self
            # @param [Symbol] style_method
            # @param [String] style
            # @return [void]
            def style_accessor(style_method, style)
              style_reader(style_method, style)
              style_writer(style_method, style)
            end

            # @see .style_accessor
            def style_reader(style_method, style)
              define_method(style_method) do
                read_internal_style(style)
              end
            end

            # @see .style_accessor
            def style_writer(style_method, style)
              define_method(:"#{style_method}=") do |value|
                write_internal_style(style, value)
              end
            end

            # @param [Array<Symbol>] style_methods
            def style_accessible(*style_methods)
              accessible_styles.concat(style_methods)
            end

            # @return [Array<Symbol>]
            def accessible_styles
              @accessible_styles ||= []
            end

            def inherited(s)
              s.accessible_styles.concat(accessible_styles.dup)
            end
          end

          # @return [Hash]
          attr_accessor :styles
          # @see .accessible_styles
          attr_reader :accessible_styles

          # @param [Thinreports::Core::Format::Base] format
          # @param [Hash] default_styles ({})
          def initialize(format, default_styles = {})
            @format = format
            @styles = default_styles
            @base_styles = format.style || {}

            @accessible_styles = self.class.accessible_styles.dup
          end

          # @param [Symbol] style_method
          # @return [Object]
          def [](style_method)
            verify_style_method(style_method)
            send(style_method.to_sym)
          end

          # @param [Symbol] style_method
          # @param [String, Number, Array<String, Number>] value
          def []=(style_method, value)
            verify_style_method(style_method)
            send(:"#{style_method}=", value)
          end

          # @return [String]
          def identifier
            create_identifier(@styles)
          end

          # @return [self]
          def copy
            self.class.new(@format, @styles.empty? ? {} : deep_copy(@styles))
          end

          # @param [String, Symbol] style
          # @return [Object]
          def read_internal_style(style)
            style = style.to_s
            @styles.key?(style) ? @styles[style] : @base_styles[style]
          end

          # @param [String, Symbol] style
          # @param [Object] value
          def write_internal_style(style, value)
            @styles[style.to_s] = value
          end

          # @param [Symbol] style_method
          # @return [Boolean]
          def has_style?(style_method)
            accessible_styles.include?(style_method)
          end

          # @return [Hash]
          def finalized_styles
            @finalized_styles ||=
              if @styles.empty?
                @base_styles.dup
              else
                @base_styles.merge(@styles)
              end
          end

          private

          # @param [Hash] s
          # @return [String]
          def create_identifier(s)
            s.empty? ? '' : s.hash.to_s
          end

          # @param [Symbol] style_method
          # @raise Thinreports::Errors::UnknownShapeStyleName
          def verify_style_method(style_method)
            return if has_style?(style_method)

            raise Thinreports::Errors::UnknownShapeStyleName.new(
              style_method,
              accessible_styles
            )
          end

          # @param [Object] value
          # @param [Array<Object>] allows
          # @param [String] msg (nil)
          # @raise ArgumentError
          def verify_style_value(value, allows, msg = nil)
            raise ArgumentError, msg unless allows.include?(value)
          end
        end
      end
    end
  end
end
