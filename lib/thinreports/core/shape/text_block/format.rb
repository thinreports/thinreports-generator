# coding: utf-8

module ThinReports
  module Core::Shape
    
    # @private
    class TextBlock::Format < Basic::BlockFormat
      config_reader :ref_id => %w( ref-id )
      config_reader :valign, :overflow
      config_reader :line_height => %w( line-height )      
      config_reader :format_base             => %w( format base ),
                    :format_type             => %w( format type ),
                    :format_datetime_format  => %w( format datetime format ),
                    :format_number_delimiter => %w( format number delimiter ),
                    :format_number_precision => %w( format number precision ),
                    :format_padding_char     => %w( format padding char ),
                    :format_padding_dir      => %w( format padding direction )

      config_checker 'true', :multiple
      config_checker 'R', :format_padding_rdir => %w( format padding direction )

      config_reader :format_padding_length => %w( format padding length ) do |len|
        len.blank? ? 0 : len.to_i
      end

      config_reader :has_format? => %w( format type ) do |type|
        %w( datetime number padding ).include?(type)
      end

      config_reader :has_reference? => %w( ref-id ) do |ref_id|
        !ref_id.blank?
      end
    end
    
  end
end
