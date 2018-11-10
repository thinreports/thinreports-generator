# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::List::TestPageState < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  List = Thinreports::Core::Shape::List

  def setup
    parent = mock('parent')
    format = mock('format')

    @state = List::PageState.new(parent, format)
  end

  def test_alias_class
    assert_same List::PageState, List::Internal
  end

  def test_type_of?
    assert_equal @state.type_of?('list'), true
  end

  def test_finalized!
    assert_equal @state.finalized?, false
    @state.finalized!
    assert_equal @state.finalized?, true
  end
end
