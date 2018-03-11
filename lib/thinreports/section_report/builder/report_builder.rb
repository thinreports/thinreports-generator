require_relative 'report_data'
require_relative 'item_builder'

module Thinreports
  module SectionReport
    module Builder
      class ReportBuilder
        def initialize(schema)
          @schema = schema
        end

        def build(params)
          ReportData::Main.new(
            schema,
            params[:start_page_number] || 1,
            build_groups(params[:groups])
          )
        end

        private

        attr_reader :schema

        def build_groups(groups_params)
          return [] unless groups_params

          groups_params.map do |group_params|
            ReportData::Group.new(
              build_sections(:header, group_params[:headers]),
              build_detail_sections(group_params[:details]),
              build_sections(:footer, group_params[:footers])
            )
          end
        end

        def build_sections(section_type, sections_params)
          sections_schemas =
            case section_type
            when :header then schema.headers
            when :footer then schema.footers
            end

          sections_schemas.each_with_object([]) do |(section_id, section_schema), sections|
            section_params = sections_params[section_id.to_sym] || {}
            next unless section_enabled?(section_schema, section_params)

            items = build_items(section_schema, section_params[:items] || {})
            sections << ReportData::Section.new(section_schema, items)
          end
        end

        def build_detail_sections(details_params)
          details_params.each_with_object([]) do |detail_params, details|
            detail_id = detail_params[:id].to_sym
            detail_schema = schema.details[detail_id]

            raise Thinreports::Errors::UnknownSectionId.new(:detail, detail_id) unless detail_schema

            items = build_items(detail_schema, detail_params[:items] || {})
            details << ReportData::Section.new(detail_schema, items)
          end
        end

        def build_items(section_schema, items_params)
          section_schema.items.each_with_object([]) do |item_schema, items|
            item = ItemBuilder.new(item_schema).build(items_params[item_schema.id.to_sym])
            items << item if item.visible?
          end
        end

        def section_enabled?(section_schema, section_params)
          section_params.key?(:display) ? section_params[:display] : section_schema.display?
        end
      end
    end
  end
end
