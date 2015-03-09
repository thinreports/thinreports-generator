# coding: utf-8

module ThinReports
  # @yield [config]
  # @yieldparam [ThinReports::Configuration] config
  def self.configure(&block)
    block_exec_on(self.config, &block)
  end

  # @return [ThinReports::Configuration]
  def self.config
    @config ||= ThinReports::Configuration.new
  end

  class Configuration
    def initialize
      @fallback_fonts = []
    end

    # @return [Array<String>]
    # @example
    #   config.fallback_fonts # => ['Times New Roman', '/path/to/font.ttf']
    def fallback_fonts
      @fallback_fonts ||= []
    end

    # @param [Array<String>,String]
    # @example
    #   config.fallback_fonts = 'Times New Roman'
    #   config.fallback_fonts = '/path/to/font.ttf'
    #   config.fallback_fonts = ['/path/to/font.ttf', 'IPAGothic']
    def fallback_fonts=(font_names)
      @fallback_fonts = font_names.is_a?(Array) ? font_names : [font_names]
    end

    # @return [ThinReports::Generator::Configuration]
    def generator
      @generator ||= ThinReports::Generator::Configuration.new
    end
  end
end
