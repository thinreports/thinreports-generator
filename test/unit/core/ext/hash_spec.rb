# coding: utf-8

require 'test/unit/helper'

describe 'Hash#simple_deep_copy' do

  it 'should original not be same as copied' do
    original = {}
    original.wont_be_same_as original.simple_deep_copy
  end
  
  it 'should not immutable elements at fist node has been cloned' do
    original = {:a => 'string', :b => Time.now}
    copied   = original.simple_deep_copy
    
    original.each do |k, v|
      v.wont_be_same_as copied[k]
    end
  end
  
  it 'should immutable objects at first node returns the raw' do
    original = {:a => nil, :b => 1, :c => 100, :d => :symbol}
    copied   = original.simple_deep_copy
    
    original.each do |k, v|
      v.must_be_same_as copied[k]
    end
  end
end
