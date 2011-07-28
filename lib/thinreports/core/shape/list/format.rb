# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class List::Format < Basic::Format
      config_reader :height => %w( content-height )
      config_checker 'true', :auto_page_break => %w( page-break )
      
      config_reader :header,
                    :detail,
                    :footer
      config_reader :page_footer => %w( page-footer )
      
      config_checker 'true', :has_header => %w( header-enabled )
      config_checker 'true', :has_footer => %w( footer-enabled )
      config_checker 'true', :has_page_footer => %w( page-footer-enabled )
      
      config_reader :page_footer_height => %w( page-footer height )
      config_reader :footer_height      => %w( footer height )
      config_reader :header_height      => %w( header height )
      config_reader :detail_height      => %w( detail height )
      
      config_accessor :sections
      
      # @param [Symbol] section_name
      # @return [Hash]
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
      
      class << self
        
      private
        
        # @param [Hash] raw_format
        # @return [ThinReports::Core::Shape::List::Format]
        def build_internal(raw_format)
          new(raw_format) do |f|
            f.sections = {}
            build_section(:detail, f)
            build_section(:header, f) if f.has_header?
            build_section(:footer, f) if f.has_footer?
            build_section(:page_footer, f) if f.has_page_footer?
          end
        end
        
        # @param [Symbol] section_name
        # @param [ThinReports::Core::Shape::List::Format] list
        # @return [ThinReports::Core::Shape::List::SectionFormat]
        def build_section(section_name, list)
          list.sections[section_name] =
            List::SectionFormat.build(list.section(section_name))
        end
      end
    end
    
  end
end
