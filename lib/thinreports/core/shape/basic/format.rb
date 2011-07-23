# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class Basic::Format < Core::Format::Base
      config_reader :type, :id
      config_reader :svg_tag     => %w( svg tag ),
                    :svg_attrs   => %w( svg attrs )
                    
      config_checker 'true', :display
      
      class << self
      private
        
        # @param [Hash] raw_format
        # @return [ThinReports::Core::Shape::Basic::Format]
        def build_internal(raw_format)
          new(raw_format)
        end
      end
    end
    
  end
end
