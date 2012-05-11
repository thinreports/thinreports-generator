# coding: utf-8

require 'test/unit/helper'

class ThinReports::Layout::TestVersion < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Version = ThinReports::Layout::Version
  
  def test_comparable_version_should_add_99_when_the_given_version_is_not_PRE
    assert_equal Version.comparable_version('0.7.0'), '0.7.0.99'
  end
  
  def test_comparable_version_should_map_pre_to_1_when_the_given_version_is_PRE
    assert_equal Version.comparable_version('0.6.0.pre'), '0.6.0.1'
  end
  
  def test_comparable_version_should_map_pre2_to_2_when_the_given_version_is_PRE2
    assert_equal Version.comparable_version('0.6.0.pre2'), '0.6.0.2'
  end
  
  def test_compare_with_equal_rule_should_return_true_when_the_given_version_is_equal_to_the_version_of_rule
    assert Version.compare('0.7.0', '== 0.7.0')
  end
  
  def test_compare_with_equal_rule_should_return_false_when_the_given_version_is_not_equal_to_the_version_of_rule
    refute Version.compare('0.6.0.pre3', '== 0.6.0.pre2')
  end
  
  def test_compare_with_larger_rule_should_return_true_when_the_given_version_is_larger_than_the_version_of_rule
    assert Version.compare('0.7.0', '> 0.6.0.pre3')
  end
  
  def test_compare_with_larger_rule_should_return_false_when_the_given_version_is_not_larger_than_the_version_of_rule
    refute Version.compare('0.7.0', '> 0.7.0')
  end
  
  def test_compare_with_one_or_more_rule_should_return_true_when_the_given_version_is_equal_to_the_version_of_rule
    assert Version.compare('0.7.0', '>= 0.7.0')
  end
  
  def test_compare_with_one_or_more_rule_should_return_true_when_the_given_version_is_larger_than_the_version_of_rule
    assert Version.compare('0.7.0', '>= 0.6.0.pre3')
  end
  
  def test_compare_with_one_or_more_rule_should_return_false_when_the_give_version_is_not_more_than_the_version_of_rule
    refute Version.compare('0.6.0.pre3', '>= 0.7.0')
  end
  
  def test_compare_with_one_or_less_rule_should_return_true_when_the_given_version_is_equal_to_the_version_of_rule
    assert Version.compare('0.7.0', '<= 0.7.0')
  end
  
  def test_compare_with_one_or_less_rule_should_return_true_when_the_given_version_is_smaller_than_the_version_of_rule
    assert Version.compare('0.7.0', '<= 0.7.1')
  end
  
  def test_compare_with_one_or_less_rule_should_return_false_when_the_given_version_is_not_less_than_the_version_of_rule
    refute Version.compare('0.7.0', '<= 0.6.0.pre3')
  end
  
  def test_inspect_required_rules_should_properly_return_an_inspection_of_rule_when_one_rule_is_given
    required_rules('== 0.6.0') do
      assert_equal Version.inspect_required_rules, '(== 0.6.0)'
    end
  end
  
  def test_inspect_required_rules_should_properly_return_an_inspection_of_rules_when_multiple_rules_are_given
    required_rules('>= 0.6.0.pre3', '< 0.8.0') do
      assert_equal Version.inspect_required_rules, '(>= 0.6.0.pre3 and < 0.8.0)'
    end
  end
  
  def test_compatible_asker_should_return_true_when_the_given_version_matches_REEQUIRED_RULES
    required_rules('>= 0.6.0.pre3', '< 0.8.0') do
      assert Version.compatible?('0.7.0')
    end
  end
  
  def test_compatible_asker_should_return_false_when_the_given_version_does_not_matches_REQUIRED_RULES
    required_rules('>= 0.6.0.pre3', '< 0.8.0') do
      refute Version.compatible?('0.8.0')
    end
  end
  
  def required_rules(*rules, &block)
    original_required_rules = Version::REQUIRED_RULES.dup
    
    Version::REQUIRED_RULES.replace(rules)
    block.call
  ensure
    Version::REQUIRED_RULES.replace(original_required_rules)
  end
end
