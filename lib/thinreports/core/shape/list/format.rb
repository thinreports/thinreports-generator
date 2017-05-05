# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module List
        class Format < Basic::Format
          config_reader height: %w[content-height]
          config_checker true, auto_page_break: %w[auto-page-break]

          # @deprecated
          config_reader :header,
                        :detail,
                        :footer
          # @deprecated
          config_reader page_footer: %w[page-footer]

          config_checker true, has_header: %w[header enabled]
          config_checker true, has_footer: %w[footer enabled]
          config_checker true, has_page_footer: %w[page-footer enabled]

          config_reader page_footer_height: %w[page-footer height]
          config_reader footer_height: %w[footer height]
          config_reader header_height: %w[header height]
          config_reader detail_height: %w[detail height]

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

          # @param [:detai, :header, :page_footer, :footer] section_name
          # @return [Numeric]
          def section_base_position_top(section_name)
            section = @sections[section_name]
            return 0 unless has_section?(section_name)

            top = section.relative_top

            case section_name
            when :page_footer
              top - section_height(:detail)
            when :footer
              top - section_height(:detail) - section_height(:page_footer)
            else
              top
            end
          end

          private

          def initialize_sections
            @sections = {
              detail: List::SectionFormat.new(attributes['detail'])
            }

            @sections[:header] = section_format('header') if has_section?(:header)
            @sections[:page_footer] = section_format('page-footer') if has_section?(:page_footer)
            @sections[:footer] = section_format('footer') if has_section?(:footer)
          end

          def section_format(section_name)
            List::SectionFormat.new(attributes[section_name])
          end
        end
      end
    end
  end
end
