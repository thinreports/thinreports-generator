require_relative 'parser'

module Thinreports
  module SectionReport
    module Schema
      class Loader
        def initialize
          @parser = Schema::Parser.new
        end

        def load_from_file(filename)
          data = File.read(filename, encoding: 'UTF-8')
          load_from_data(data)
        end

        def load_from_data(data)
          parser.parse(data)
        end

        private

        attr_reader :parser
      end
    end
  end
end
