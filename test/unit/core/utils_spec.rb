# coding: utf-8

require 'test/unit/helper'

include ThinReports::TestHelpers

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

describe '#ruby_18' do
  it 'should not be run and return false if ruby version more than 1.8' do
    skip_if_ruby18
    
    ruby_18 {
      flunk '#ruby_18 should not be executed!'
    }.must_equal false
  end
  
  it 'should be run if ruby version less than 1.9' do
    skip_if_ruby19

    ruby_18 {
      pass '#ruby_18 was executed correctly!'; true
    }.must_equal true
  end
end

describe '#ruby_19' do
  it 'should not be run and return false if ruby version less than 1.9' do
    skip_if_ruby19
    
    ruby_19 {
      flunk '#ruby_19 should not be executed!'
    }.must_equal false
  end
  
  it 'should be run if ruby version more than 1.9' do
    skip_if_ruby18
    
    ruby_19 {
      pass '#ruby_19 was executed correctly!'; true
    }.must_equal true
  end
end
