# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Format::BaseTest < MiniTest::Unit::TestCase
  TEST_FORMAT_CONFIG = {
    'c1' => 'c1',
    'c2' => {
      'c2_1' => 'c2_1'
    },
    'c3' => {
      'c3_1' => {
        'c3_1_1' => 'c3_1_1',
        'c3_1_2' => 'c3_1_2'
      }
    },
    'c4' => 'c4', 
    'c5' => 'c5',
    'c6' => 9999,
    'c7' => 'true',
    'c8' => 'false', 
    'c9' => {
      'c9_1' => 'true',
      'c9_2' => 'false'
    },
    'c10' => 'c10', 
    'c11' => {
      'c11_1' => 'c11_1'
    },
    'c20' => 'c20',
    'c21' => 'c21'
  }
  
  class TestFormat < ThinReports::Core::Format::Base
    # For testing
    attr_reader :config
    
    # Basic methods
    config_reader :c1
    config_reader :c2_1       => %w( c2 c2_1 ), 
                  :c3_1_1     => %w( c3 c3_1 c3_1_1 )
    config_reader :c4, :c5
    config_reader 'c6'
    
    # Alias methods
    config_reader :c1_alias   => %w( c1 ),
                  :c2_1_alias => %w( c2 c2_1 )
    
    # Invalid methods
    config_reader :c3_invalid => %w( c3 c3_1 not_exist_key )  
    
    # Customized methods
    config_reader :c2_1_customized => %w( c2 c2_1 ) do |val|
      "Customized #{val}"
    end
    
    # Checker methods
    config_checker 'true', :c7, :c8
    config_checker 'true', :c9_1 => %w( c9 c9_1 ),
                           :c9_2 => %w( c9 c9_2 )
    
    # Writer methods
    config_writer :c10
    config_writer :c10_alias => %w( c10 )
    config_writer :c11_1 => %w( c11 c11_1 )
    # Writer for not exist config on default
    config_writer :c11_2 => %w( c11 c11_2 )
    
    # Accessor methods
    config_accessor :c20
    config_accessor :c21 do |val|
      "Customized #{val}"
    end
  end

  def setup
    @format = TestFormat.new(TEST_FORMAT_CONFIG)
  end
  
  def test_definition_of_all_config_methods
    methods = [:c1, :c2_1, :c3_1_1, :c4, :c5, :c6,
               :c1_alias, :c2_1_alias,
               :c3_invalid,
               :c2_1_customized,
               :c7?, :c8?, :c9_1?, :c9_2?,
               :c10=, :c10_alias=, :c11_1=, :c11_2=,
               :c20, :c20=, :c21, :c21=]
    assert methods.all? {|m| TestFormat.method_defined?(m) }
  end
  
  def test_readers
    # Basic
    assert_equal @format.c1, 'c1'
    assert_equal @format.c2_1, 'c2_1'
    assert_equal @format.c3_1_1, 'c3_1_1'
    assert_equal @format.c4, 'c4'
    assert_equal @format.c5, 'c5'
    assert_equal @format.c6, 9999
    # Alias
    assert_equal @format.c1_alias, @format.c1
    assert_equal @format.c2_1_alias, @format.c2_1
    # Invalid location
    assert_nil @format.c3_invalid
    # Customized
    assert_equal @format.c2_1_customized, 'Customized c2_1'
  end
  
  def test_checkers
    assert_equal @format.c7?, true
    assert_equal @format.c8?, false
    assert_equal @format.c9_1?, true
    assert_equal @format.c9_2?, false
  end
  
  def test_reader_cannot_write_value
    assert_raises NoMethodError do
      @format.c1 = 'write'
    end
    # Alias method
    assert_raises NoMethodError do
      @format.c1_alias = 'write'
    end
  end
  
  def test_writers
    config = @format.config
    
    @format.c10 = 'c1_changed'
    assert_equal config['c10'], 'c1_changed'
    
    @format.c10_alias = 'c10_changed_by_alias'
    assert_equal config['c10'], 'c10_changed_by_alias'
    
    @format.c11_1 = 'c11_1_changed'
    assert_equal config['c11']['c11_1'], 'c11_1_changed'
    
    @format.c11_2 = 'c11_2_created'
    assert_equal config['c11']['c11_2'], 'c11_2_created'
  end
  
  def test_accessors
    @format.c20 = 'c20_changed'
    assert_equal @format.c20, 'c20_changed'
    
    @format.c21 = 'c21_changed'
    assert_equal @format.c21, 'Customized c21_changed'
  end
end