# coding: utf-8
require 'json'

module Thinreports
  module Layout
    class Format < Core::Shape::Manager::Format
      config_reader last_version: %w( version )
      config_reader report_title: %w( title )
      config_reader page_paper_type: %w( report paper-type ),
                    page_width: %w( report width ),
                    page_height: %w( report height ),
                    page_orientation: %w( report orientation )

      class << self
        def build(filename)
          schema = JSON.parse(read_file(filename))

          unless Layout::Version.compatible?(schema['version'])
            raise Errors::IncompatibleLayoutFormat.new(
              filename, schema['version'], Thinreports::Layout::Version.inspect_required_rules
            )
          end

          if schema['version'] < '0.9.0'
            warn '[DEPRECATION] Loading regacy layout format is deprecated and will be removed in thinreports-generator 1.0.' \
                 ' Please convert to new layout format using Thinreports Editor 0.9.x.'
            schema = Layout::RegacySchema.new(schema).upgrade
          end

          new schema
        end

        def read_file(filename)
          File.open(filename, 'r:UTF-8') {|f| f.read }
        end
      end

      def initialize(*)
        super
        initialize_items(attributes['items'])
      end

      def user_paper_type?
        page_paper_type == 'user'
      end

      private

      def initialize_items(item_schemas)
        item_schemas.each do |item_schema|
          id, type = item_schema.values_at 'id', 'type'

          next if id.empty? && type != 'page-number'

          item = Core::Shape::Format(type).new(item_schema)
          self.shapes[item.id.to_sym] = item
        end
      end
    end
  end
end
