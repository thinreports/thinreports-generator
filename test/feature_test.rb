# frozen_string_literal: true

require 'pdf_matcher/testing/minitest_adapter'

PdfMatcher.config.diff_pdf_opts = %w(
  --mark-differences
  --channel-tolerance=40
)

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
          assert_match_pdf expect_pdf, actual_pdf, output_diff: path_of('diff.pdf')
        else
          flunk 'expect.pdf does not exist.'
        end
      rescue PdfMatcher::DiffPdf::CommandNotAvailable
        skip 'The feature test was skipped because the diff-pdf command is not available; please install diff-pdf (https://github.com/vslavik/diff-pdf) and try again.'
      end

      def template_path(filename = 'template.tlf')
        dir.join(filename).to_path
      end

      private

      def actual_pdf
        dir.join('actual.pdf')
      end

      def expect_pdf
        dir.join('expect.pdf')
      end
    end
  end
end
