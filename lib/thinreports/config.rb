# frozen_string_literal: true

module Thinreports
  # @yield [config]
  # @yieldparam [Thinreports::Configuration] config
  def self.configure(&block)
    Thinreports.call_block_in(config, &block)
  end

  # @return [Thinreports::Configuration]
  def self.config
    @config ||= Thinreports::Configuration.new
  end

  class Configuration
    def initialize
      @fallback_fonts = []
      @fonts = {}
    end

    # @return [Array<String>]
    # @example
    #   config.fallback_fonts # => ['Times New Roman', '/path/to/font.ttf']
    def fallback_fonts
      @fallback_fonts ||= []
    end

    # @param [Array<String>,String] font_names
    # @example
    #   config.fallback_fonts = 'Times New Roman'
    #   config.fallback_fonts = '/path/to/font.ttf'
    #   config.fallback_fonts = ['/path/to/font.ttf', 'IPAGothic']
    def fallback_fonts=(font_names)
      @fallback_fonts = font_names.is_a?(Array) ? font_names : [font_names]
    end

    # @param [String] name
    # @param [String] normal (required) Path for normal style font
    # @param [String] bold Path for bold style font. Set :normal by default.
    # @param [String] italic Path for italic style font. Set :normal by default.
    # @param [String] bold_italic Path for bold+italic style font. Set :normal by default.
    # @example
    #   config.register_font('Foo Font',
    #     normal: '/path/to/foo.ttf',
    #     bold: '/path/to/foo_bold.ttf',
    #     italic: '/path/to/foo_italic.ttf',
    #     bold_italic: '/path/to/foo_bold_italic.ttf'
    #   )
    #
    #   # For fonts that have no style, such as Japanese:
    #   config.register_font('Bar Font', normal: '/path/to/bar.tlf')
    #   => {
    #     normal: '/path/to/bar.tlf',
    #     bold: '/path/to/bar.tlf,'
    #     italic: '/path/to/bar.tlf,'
    #     bold_italic: '/path/to/bar.tlf,'
    #   }
    def register_font(name, normal:, bold: normal, italic: normal, bold_italic: normal)
      @fonts[name] = {
        normal: normal,
        bold: bold,
        italic: italic,
        bold_italic: bold_italic
      }
    end

    attr_reader :fonts
  end
end
