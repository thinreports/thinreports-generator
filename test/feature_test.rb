# frozen_string_literal: true

module Thinreports
  module FeatureTest
    def self.[](base_dir)
      k = Class.new(Base)
      k.class_eval %Q{
        def dir
          Pathname.new('#{base_dir}')
        end
      }
      k
    end

    class Base < Minitest::Test
      class << self
        def feature(&block)
          define_method(:test_feature, &block)
        end
      end

      def dir
        raise NotImplementedError
      end

      def path_of(filename)
        dir.join(filename).to_path
      end

      def assert_pdf(actual)
        actual_pdf.binwrite(actual)

        if expect_pdf.exist?
          assert match_expect_pdf?, 'Does not match expect.pdf. Check diff.pdf for details.'
        else
          flunk 'expect.pdf does not exist.'
        end
      end

      def template_path(filename = 'template.tlf')
        dir.join(filename).to_path
      end

      private

      def feature_name
        self.class.name
      end

      def match_expect_pdf?
        opts = [
          '--mark-differences',
          # Allow for small differences that cannot be seen
          '--channel-tolerance=40'
        ]
        system("diff-pdf #{opts.join(' ')} --output-diff=#{path_of('diff.pdf')} #{expect_pdf} #{actual_pdf}")
      end

      def actual_pdf
        dir.join('actual.pdf')
      end

      def expect_pdf
        dir.join('expect.pdf')
      end
    end
  end
end
