# coding: utf-8

module ThinReports
  module Layout
    
    module Version
      REQUIRED_RULES = ["== #{ThinReports::VERSION}"]
      
      def self.compatible?(version)
        compare(version, *REQUIRED_RULES)
      end
      
      def self.compare(base, *rules)
        rules.all? do |rule|
          op, ver = rule.split(' ')
          comparable_version(base).send(op.to_sym, comparable_version(ver))
        end
      end
      
      def self.required_rules_inspect
        '(' + REQUIRED_RULES.join(' and ') + ')'
      end
      
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
