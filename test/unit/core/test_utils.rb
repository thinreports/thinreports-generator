# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::TestShape < Minitest::Test
  include Thinreports::TestHelper
  include Thinreports::Utils

  def test_call_block_in
    expected = '123'
    assert_same expected, call_block_in(expected)

    assert_equal [1, 2, 3], call_block_in([2, 1, 3], &proc { sort! })
    assert_equal [1, 2, 3], call_block_in([2, 1, 3], &proc { |a| a.sort! })
  end

  def test_deep_copy_in_unsupported_object
    [123, nil, Struct.new(:foo).new].each do |unsupported_value|
      assert_raises ArgumentError do
        deep_copy(unsupported_value)
      end
    end
  end

  def test_deep_copy_in_Array
    src = ['string', Time.now]
    dup = deep_copy(src)

    refute_same dup, src

    src.each_with_index do |e, i|
      assert_equal dup[i], e
      refute_same dup[i], e
    end
  end

  def test_deep_copy_in_Hash
    src = { a: 'string', b: Time.now }
    dup = deep_copy(src)

    refute_same dup, src

    src.each do |k, v|
      assert_equal dup[k], v
      refute_same dup[k], v
    end
  end

  def test_blank_value_in_String
    ["", ''].each do |val|
      assert_equal true, blank_value?(val)
    end

    [' ', '　', 'abc', 'あいう'].each do |val|
      assert_equal false, blank_value?(val)
    end
  end

  def test_blank_value_in_NilClass
    assert_equal true, blank_value?(nil)
  end

  def test_blank_value_in_other_classes
    [0, 1, -1, 9.99, true, false, Time.now].each do |val|
      assert_equal false, blank_value?(val)
    end
  end
end
