# coding: utf-8

module ThinReports
  module Generator
    
    class Configuration
      # @return [ThinReports::Generator::Pdf::Configuration]
      def pdf
        @pdf ||= Pdf::Configuration.new
      end
    end
    
  end
end