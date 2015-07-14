# coding: utf-8

module Thinreports
  # @yield [config]
  # @yieldparam [Thinreports::Configuration] config
  def self.configure(&block)
    Thinreports.call_block_in(self.config, &block)
  end

  # @return [Thinreports::Configuration]
  def self.config
    @config ||= Thinreports::Configuration.new
  end

  class Configuration
    def initialize
      @fallback_fonts = []
      @convert_palleted_transparency_png = false
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

    # @return [Boolean]
    # @see https://github.com/thinreports/thinreports-generator/pull/32
    attr_reader :convert_palleted_transparency_png

    # @param [Boolean]
    # @example
    #   config.convert_palleted_transparency_png = true
    #   config.convert_palleted_transparency_png = false # default
    # @see https://github.com/thinreports/thinreports-generator/pull/32
    def convert_palleted_transparency_png=(enable)
      @convert_palleted_transparency_png = enable
    end

    # @return [Thinreports::Generator::Configuration]
    def generator
      @generator ||= Thinreports::Generator::Configuration.new
    end
  end
end
