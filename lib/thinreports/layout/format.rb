# frozen_string_literal: true

require 'json'

module Thinreports
  module Layout
    class Format < Core::Shape::Manager::Format
      config_reader last_version: %w[version]
      config_reader report_title: %w[title]
      config_reader page_paper_type: %w[report paper-type],
                    page_width: %w[report width],
                    page_height: %w[report height],
                    page_orientation: %w[report orientation]

      class << self
        def build(filename)
          schema = JSON.parse(read_file(filename))
          schema_version = Layout::Version.new(schema['version'])

          unless schema_version.compatible?
            raise Errors::IncompatibleLayoutFormat.new(
              filename, schema['version'],
              Layout::Version.compatible_rules.join(' and ')
            )
          end

          if schema_version.legacy?
            warn '[DEPRECATION] Support for the layout file with old format' \
                 ' that generated with Editor 0.8 or lower will be dropped in Thinreports 1.1.' \
                 ' Please convert to new layout format using Thinreports Editor 0.9 or 1.0.'
            schema = Layout::LegacySchema.new(schema).upgrade
          end

          new schema
        end

        def read_file(filename)
          File.read(filename, encoding: 'UTF-8')
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
          shapes[item.id.to_sym] = item
        end
      end
    end
  end
end
