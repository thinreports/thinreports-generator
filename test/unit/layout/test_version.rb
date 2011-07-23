# coding: utf-8

require 'test/unit/helper'

class ThinReports::Layout::TestVersion < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Version = ThinReports::Layout::Version
  
  def test_comparable_version
    assert_equal Version.comparable_version('0.6.0'), '0.6.0.99'
    assert_equal Version.comparable_version('0.6.0.pre'), '0.6.0.1'
    assert_equal Version.comparable_version('0.6.0.pre2'), '0.6.0.2'
  end
  
  def test_compare_with_simple_rule
    assert Version.compare('0.6.0', '== 0.6.0')
    refute Version.compare('0.6.0', '== 0.6.1')
    
    refute Version.compare('0.6.0', '> 0.6.0')
    assert Version.compare('0.6.1', '> 0.6.0')
    assert Version.compare('0.6.0', '> 0.5.9')
    assert Version.compare('0.6.0', '> 0.6.0.pre3')
    assert Version.compare('0.6.0.pre2', '> 0.6.0.pre')
    
    assert Version.compare('0.6.0.pre', '< 0.6.0.pre3')
    
    assert Version.compare('0.6.0', '>= 0.6.0')
    assert Version.compare('0.6.0', '<= 0.6.0')
  end
  
  def test_compare_with_multiple_rules
    assert Version.compare('0.6.0', '> 0.5.0', '< 1.0.0')
    refute Version.compare('0.6.5', '> 0.6.0', '< 0.6.4')
  end
  
  def test_compatible?
    required_rules('== 0.6.0.pre3') do
      assert Version.compatible?('0.6.0.pre3')
    end
  end
  
  def test_required_rules_inspect
    required_rules('== 0.6.0.pre3') do
      assert_equal Version.required_rules_inspect, '(== 0.6.0.pre3)'
    end
    required_rules('> 0.6.0', '< 0.7.0') do
      assert_equal Version.required_rules_inspect, '(> 0.6.0 and < 0.7.0)'
    end
  end
  
  def required_rules(*rules, &block)
    original_required_rules = Version::REQUIRED_RULES.dup
    
    Version::REQUIRED_RULES.clear
    rules.each {|rule| Version::REQUIRED_RULES << rule }
    block.call
  ensure
    original_required_rules.each {|rule| Version::REQUIRED_RULES << rule }
  end
end
