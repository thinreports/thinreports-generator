# coding: utf-8

require 'test/unit/helper'

describe 'Array#simple_deep_copy' do

  it 'should original not be same as copied' do
    original = []
    original.wont_be_same_as original.simple_deep_copy
  end
  
  it 'should not immutable elements at fist node has been cloned' do
    original = ['element', Time.now]
    copied   = original.simple_deep_copy
    
    original.each_with_index do |o, i|
      o.wont_be_same_as copied[i]
    end
  end
  
  it 'should immutable objects at first node returns the raw' do
    original = [nil, 1, 100, :symbol]
    copied   = original.simple_deep_copy
    
    original.each_with_index do |o, i|
      o.must_be_same_as copied[i]
    end
  end
end
