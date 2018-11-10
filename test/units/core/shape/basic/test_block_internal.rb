# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Basic::TestBlockInternal < Minitest::Test
  include Thinreports::TestHelper

  Basic = Thinreports::Core::Shape::Basic

  def test_read_value_should_return_value_from_format
    internal = init_internal('value' => 'default value')
    assert_equal internal.read_value, 'default value'
  end

  def test_read_value_should_return_value_from_state_with_value_key
    internal = init_internal
    internal.states[:value] = 'new value'
    assert_equal internal.read_value, 'new value'
  end

  def test_real_value_should_return_the_same_value_as_a_read_value_method
    internal = init_internal
    internal.states[:value] = 'foo'
    assert_same internal.real_value, internal.read_value
  end

  def test_write_value_should_save_value_to_states_store_as_value
    internal = init_internal
    internal.write_value('new value')
    assert_equal internal.states[:value], 'new value'
  end

  def test_type_of_asker_should_return_true_when_given_the_block_value
    assert_equal init_internal.type_of?(:block), true
  end

  def test_value_should_works_the_same_as_read_value_method
    internal = init_internal
    internal.write_value('new value')
    assert_same internal.read_value, internal.value
  end

  def test_type_of_asker_should_return_false_otherwise
    assert_equal %w( image-block text-block text list ).all? {|t| !init_internal.type_of?(t)}, true
  end

  private

  def init_internal(format = {})
    report = Thinreports::Report.new layout: layout_file.path
    parent = report.start_new_page

    Basic::BlockInternal.new(parent, Basic::BlockFormat.new(format))
  end
end
