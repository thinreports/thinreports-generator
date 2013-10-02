# coding: utf-8

module ThinReports
  module Core::Shape

    class PageNumber::Internal < Basic::Internal
      format_delegators :box

      def read_format
        states.key?(:format) ? states[:format] : format.default_format.dup
      end

      def reset_format
        states.delete(:format)
      end

      def write_format(format)
        states[:format] = format.to_s
      end

      def build_format(page_no, page_count)
        return '' if read_format.blank?

        unless format.start_at.zero?
          page_no += format.start_at
          page_count += format.start_at
        end

        read_format.dup.tap do |f|
          f.gsub! '{page}', page_no.to_s
          f.gsub! '{total}', page_count.to_s
        end
      end

      def style
        @style ||= PageNumber::Style.new(format)
      end

      def for_report?
        format.target.blank?
      end

      def type_of?(type_name)
        type_name == :pageno
      end
    end

    class PageNumber::Style < Style::Text
      accessible_styles.delete :valign
    end

  end
end
