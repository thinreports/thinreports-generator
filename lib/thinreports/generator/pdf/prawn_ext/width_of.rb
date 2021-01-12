# frozen_string_literal: true

module Thinreports
  module Generator
    module PrawnExt
      module WidthOf
        # This patch fixes the character_spacing effect on text width calculation.
        #
        # The original #width_of:
        #
        #   width_of('abcd') #=> 4 + 4 = 8
        #
        # The #width_of in this patch:
        #
        #   width_of('abcd') #=> 4 + 3 = 7
        #
        def width_of(*)
          width = super - character_spacing
          width > 0 ? width : 0
        end
      end
    end
  end
end

# Prawn v2.3 and later includes this patch by https://github.com/prawnpdf/prawn/pull/1117.
if Prawn::VERSION < '2.3.0'
  Prawn::Document.prepend Thinreports::Generator::PrawnExt::WidthOf
end
