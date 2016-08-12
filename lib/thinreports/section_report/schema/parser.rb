require 'json'

require_relative 'report'
require_relative 'section'

module Thinreports
  module SectionReport
    module Schema
      class Parser
        def parse(schema_json_data)
          schema_data = JSON.parse(schema_json_data)

          section_schema_datas = schema_data['sections'].group_by { |section| section['type'] }

          Schema::Report.new(
            schema_data,
            headers: parse_sections(:header, section_schema_datas['header']),
            details: parse_sections(:detail, section_schema_datas['detail']),
            footers: parse_sections(:footer, section_schema_datas['footer'])
          )
        end

        private

        attr_reader :schema_data

        def parse_sections(section_type, section_schema_datas)
          section_schema_datas.each_with_object({}) do |section_schema_data, section_schemas|
            id, type = section_schema_data.values_at 'id', 'type'
            section_schemas[id.to_sym] = parse_section(section_type, section_schema_data)
          end
        end

        def parse_section(type, section_schema_data)
          items = section_schema_data['items'].map do |item_schema_data|
            item_type = item_schema_data['type']
            Core::Shape::Format(item_type).new(item_schema_data)
          end
          section_schema_class_for(type).new(section_schema_data, items: items)
        end

        def section_schema_class_for(section_type)
          Schema::Section.const_get(section_type.capitalize)
        end
      end
    end
  end
end
