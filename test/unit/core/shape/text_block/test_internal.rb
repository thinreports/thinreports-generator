# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::TextBlock::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  TextBlock = ThinReports::Core::Shape::TextBlock
  
  def create_parent
    report = create_basic_report('basic_layout1.tlf')
    report.start_new_page do |page|
      # Add to force TextBlock shape.
      page.manager.format.shapes[:foo] = TextBlock::Format.new('type' => 's-tblock',
                                                               'id'   => 'foo')
      # Set value to TextBlock.
      page.item(:foo).value('foo value')
    end
  end
  
  def create_internal(format_config = {})
    TextBlock::Internal.new(create_parent, TextBlock::Format.new(format_config))
  end
  
  def test_multiple_asker_should_operate_as_delegator_of_format
    tblock = create_internal('multiple' => 'true')
    assert_equal tblock.multiple?, tblock.format.multiple?
  end
  
  def test_style_should_return_the_instance_of_Style_Text
    assert_instance_of ThinReports::Core::Shape::Style::Text, create_internal.style
  end
  
  def test_read_value_should_return_the_format_value_as_default
    tblock = create_internal('value' => 'default value')
    assert_equal tblock.read_value, 'default value'
  end
  
  def test_read_value_should_return_the_value_of_referenced_shape
    tblock = create_internal('ref-id' => 'foo')
    assert_equal tblock.read_value, 'foo value'
  end
  
  def test_read_value_should_return_the_value_stored_in_states
    tblock = create_internal
    tblock.states[:value] = 'value in states'
    
    assert_equal tblock.read_value, 'value in states'
  end
  
  def test_write_value_should_properly_set_the_specified_value_to_states
    tblock = create_internal
    tblock.write_value(1000)
    
    assert_equal tblock.states[:value], 1000
  end
  
  def test_write_value_should_show_warnings_when_tblock_has_reference
    tblock = create_internal('id' => 'bar', 'ref-id' => 'foo')
    out, err = capture_io do
      tblock.write_value('value')
    end
    assert_equal err.chomp, 'The set value was not saved, ' +
                            "Because 'bar' refers to 'foo'."
  end
  
  def test_real_value_should_return_the_formatted_value_when_tblock_has_any_format
    tblock = create_internal('format' => {'type'     => 'datetime',
                                          'datetime' => {'format' => '%Y/%m/%d'}})
    tblock.write_value(value = Time.now)
    
    assert_equal tblock.real_value, value.strftime('%Y/%m/%d')
  end
  
  def test_real_value_should_return_the_raw_value_when_tblock_has_no_format
    tblock = create_internal
    tblock.write_value('any value')
    
    assert_equal tblock.real_value, 'any value'
  end
  
  def test_format_enabled_should_properly_set_value_to_states_as_format_enabled
    tblock = create_internal
    tblock.format_enabled(false)
    
    assert_equal tblock.states[:format_enabled], false
  end
  
  def test_format_enabled_asker_should_return_true_when_format_has_any_type
    tblock = create_internal('format' => {'type' => 'datetime'})
    
    assert_equal tblock.format_enabled?, true
  end
  
  def test_format_enabled_asker_should_return_true_when_base_of_format_has_any_value
    tblock = create_internal('format' => {'base' => '{value}'})
    
    assert_equal tblock.format_enabled?, true
  end
  
  def test_format_enabled_asker_should_return_false_when_format_has_no_type_and_base_has_not_value
    assert_equal create_internal.format_enabled?, false
  end
  
  def test_format_enabled_asker_should_return_false_constantly_when_tblock_is_multiple_mode
    tblock = create_internal('multiple' => 'true', 
                             'format'   => {'base' => '{value}',
                                            'type' => 'number'})
    tblock.format_enabled(true)
    
    assert_equal tblock.format_enabled?, false
  end
  
  def test_type_of_asker_should_return_true_when_value_is_tblock
    assert_equal create_internal.type_of?(:tblock), true
  end
  
  def test_type_of_asker_should_return_true_when_value_is_block
    assert_equal create_internal.type_of?(:block), true
  end
  
  def test_formatter_should_return_instance_of_FormatterBasic_when_format_is_enable
    tblock = create_internal('format' => {'type' => 'datetime'})
    
    assert_kind_of TextBlock::Formatter::Basic, tblock.send(:formatter)
  end
end