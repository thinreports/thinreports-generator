# coding: utf-8

module ThinReports
  module Core::Shape

    class PageNumber::Format < Basic::Format
      config_reader :overflow, :target, :box
      config_reader :default_format => %w( format )

      def id
        unless @id
          @id = read('id')
          @id = self.class.next_default_id if @id.blank?
        end
        @id
      end

      def start_at
        unless @start_at
          @start_at = read('start-at').to_i - 1
          @start_at = 0 if @start_at < 0
        end
        @start_at
      end

      def self.next_default_id
        @id_counter ||= 0
        "__pageno#{@id_counter += 1}"
      end
    end

  end
end
