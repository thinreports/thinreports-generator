# coding: utf-8

require 'test_helper'

include ThinReports::TestHelper

describe '#block_exec_on' do
  it 'should return raw context if not given a block' do
    expected = '123'
    block_exec_on(expected).must_be_same_as expected
  end

  it 'should be run correctly without receiver if no block argument' do
    block_exec_on('123', &proc{ reverse! }).must_equal '321'
  end

  it 'should be run correctly with an receiver if block has an argument' do
    block_exec_on([2, 1, 3], &proc{ |a| a.sort! }).must_equal [1, 2, 3]
  end
end
