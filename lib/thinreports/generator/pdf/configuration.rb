# coding: utf-8

module ThinReports
  module Generator
    
    class Pdf::Configuration
      # @return [false, String]
      attr_accessor :manage_templates
      
      # @return [Array]
      attr_reader :eudc_ttf
      
      def initialize
        @manage_templates = false
        @eudc_ttf         = []
      end
      
      # @param [String, Array<String>]
      def eudc_ttf=(ttfs)
        ttfs = [ttfs] unless ttfs.is_a?(::Array)
        
        ttfs.each do |ttf|
          unless File.extname(ttf.to_s) == '.ttf'
            raise ArgumentError, 'The EUDC Fonts can specify only the TTF file.'
          end
        end
        @eudc_ttf = ttfs
      end
      
      # @return [Boolean]
      def manage_templates?
        @manage_templates
      end
    end
    
  end
end
