# coding: utf-8

# @private
module Prawn
  # @private
  class Document
    # Create around alias.
    alias_method :original_width_of, :width_of
    
    def width_of(string, options={})
      font.compute_width_of(string, options) +
        (character_spacing * font.character_count(string) - 1)
    end
  end
end
