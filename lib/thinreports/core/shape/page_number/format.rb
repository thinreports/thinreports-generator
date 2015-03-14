# coding: utf-8

module Thinreports
  module Core::Shape

    class PageNumber::Format < Basic::Format
      config_reader :overflow, :target, :box
      config_reader default_format: %w( format )

      def id
        unless @id
          @id = read('id')
          @id = self.class.next_default_id if @id.blank?
        end
        @id
      end

      def self.next_default_id
        @id_counter ||= 0
        "__pageno#{@id_counter += 1}"
      end
    end

  end
end
