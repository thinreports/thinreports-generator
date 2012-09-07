# coding: utf-8

module ThinReports
  module Layout
    
    # @private
    module Version
      REQUIRED_RULES = ['>= 0.6.0.pre3', '< 0.8.0']
      
      # @param [String] version
      # @return [Boolean]
      def self.compatible?(version)
        compare(version, *REQUIRED_RULES)
      end
      
      # @param [String] base
      # @param [Array<String>] rules
      # @return [Boolean]
      def self.compare(base, *rules)
        rules.all? do |rule|
          op, ver = rule.split(' ')
          comparable_version(base).send(op.to_sym, comparable_version(ver))
        end
      end
      
      # @return [String]
      def self.inspect_required_rules
        '(' + REQUIRED_RULES.join(' and ') + ')'
      end
      
      # @param [String] version
      # @return [String]
      def self.comparable_version(version)
        if version =~ /pre/
          version.sub(/pre(\d*)$/) { $1 == '' ? '1' : $1 }
        else
          "#{version}.99"
        end
      end
    end
    
  end
end
