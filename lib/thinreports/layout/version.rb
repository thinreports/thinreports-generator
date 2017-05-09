# frozen_string_literal: true

module Thinreports
  module Layout
    class Version
      COMPATIBLE_RULES = ['>= 0.8.0', '< 1.0.0'].freeze
      NEW_SCHEMA_FROM = '0.9.0'.freeze

      class << self
        def compatible_rules
          COMPATIBLE_RULES
        end
      end

      def initialize(schema_version)
        @schema_version = normalize_version(schema_version)
      end

      def compatible?
        self.class.compatible_rules.all? do |rule|
          op, ver = rule.split(' ')
          schema_version.send(op.to_sym, normalize_version(ver))
        end
      end

      def legacy?
        @schema_version < normalize_version(NEW_SCHEMA_FROM)
      end

      private

      attr_reader :schema_version

      def normalize_version(version)
        Gem::Version.create(version)
      end
    end
  end
end
