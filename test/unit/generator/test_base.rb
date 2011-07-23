# coding: utf-8

require 'test/unit/helper'

class ThinReports::Generator::TestBase < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Generator = ThinReports::Generator
  
  class FooHoge < Generator::Base; end
  
  def test_subcclasses_are_registered_as_generator_when_inherited
    assert_same FooHoge, Generator.registry.delete(:foohoge)
  end
  
  def test_initialize_finalize_given_the_report
    report = flexmock('report').
               should_receive(:finalize).once.
               should_receive(:internal).once.mock
    
    Generator::Base.new(report)
  end
  
  def test_generate_is_abstract_method
    assert_raises NotImplementedError do
      new_generator.generate
    end
  end
  
  def test_generate_file_is_abstract_method
    assert_raises NotImplementedError do
      new_generator.generate_file('output.pdf')
    end
  end
  
  def test_default_layout
    generator = new_generator
    flexmock(generator.report).
      should_receive(:default_layout).and_return(flexmock('default_layout')).once
    
    assert_equal generator.default_layout.flexmock_name, 'default_layout'
  end
  
  def new_generator
    report = flexmock('report').
              should_receive(:finalize).
              should_receive(:internal).and_return(flexmock('report_internal')).mock
    Generator::Base.new(report)
  end
end