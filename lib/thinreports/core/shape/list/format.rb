# coding: utf-8

module Thinreports
  module Core::Shape

    class List::Format < Basic::Format
      config_reader height: %w( content-height )
      config_checker true, auto_page_break: %w( auto-page-break )

      # @deprecated
      config_reader :header,
                    :detail,
                    :footer
      # @deprecated
      config_reader page_footer: %w( page-footer )

      config_checker true, has_header: %w( header enabled )
      config_checker true, has_footer: %w( footer enabled )
      config_checker true, has_page_footer: %w( page-footer enabled )

      config_reader page_footer_height: %w( page-footer height )
      config_reader footer_height: %w( footer height )
      config_reader header_height: %w( header height )
      config_reader detail_height: %w( detail height )

      attr_reader :sections

      def initialize(*)
        super
        initialize_sections
      end

      # @param [Symbol] section_name
      # @return [Hash]
      # @deprecated
      def section(section_name)
        __send__(section_name)
      end

      # @param [Symbol] section_name
      # @return [Boolean]
      def has_section?(section_name)
        section_name == :detail ? true : __send__(:"has_#{section_name}?")
      end

      # @param [Symbol] section_name
      # @return [Numeric]
      def section_height(section_name)
        has_section?(section_name) ? __send__(:"#{section_name}_height") : 0
      end

      private

      def initialize_sections
        @sections = {
          detail: List::SectionFormat.new(attributes['detail'])
        }

        @sections[:header] = List::SectionFormat.new(attributes['header']) if has_section?(:header)
        @sections[:page_footer] = List::SectionFormat.new(attributes['page-footer']) if has_section?(:page_footer)
        @sections[:footer] = List::SectionFormat.new(attributes['footer']) if has_section?(:footer)
      end
    end

  end
end
