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
    # @return [ThinReports::Generator::Configuration]
    def generator
      @generator ||= ThinReports::Generator::Configuration.new
    end
  end
end