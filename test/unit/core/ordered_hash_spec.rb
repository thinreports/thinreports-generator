# coding: utf-8

require 'test/unit/helper'

include ThinReports::TestHelpers

describe 'OrderedHash#[]=' do
  before do
    skip_if_ruby19
    @ohash = ThinReports::Core::OrderedHash.new
  end
  
  it 'should be given keys in stored in the keys array' do
    @ohash[:foo]  = 'foo'
    @ohash[:hoge] = 'hoge'
    @ohash.instance_variable_get(:@keys).must_equal [:foo, :hoge]
  end
  
  it 'should properly set the given value' do
    @ohash[:foo] = 'foo'
    @ohash[:foo].must_equal 'foo'
  end
  
  it 'should not exist a duplicate key in store of key' do
    @ohash[:foo] = 'foo1'
    @ohash[:foo] = 'foo2'
    @ohash.instance_variable_get(:@keys).uniq.size.must_equal 1
  end
end

describe 'OrderedHash#each_key' do
  it 'should get the key in the order registerd' do
    skip_if_ruby19
    
    ohash = ThinReports::Core::OrderedHash.new    
    (keys = [:key3, :key1, :key2]).each {|key| ohash[key] = key.to_s }
    
    i = 0
    ohash.each_key do |key|
      key.must_equal keys[i]; i += 1
    end
  end
end

describe 'OrderedHash on Ruby 1.9' do
  it 'should same Hash class on Ruby 1.9' do
    skip_if_ruby18
    
    ThinReports::Core::OrderedHash.must_be_same_as ::Hash
  end
end
