# coding: utf-8

require 'test/unit/helper'

describe 'String#blank?' do
  it 'should return the true value if self is empty' do
    ''.blank?.must_equal true
    "".blank?.must_equal true
  end
  
  it 'should return the false value if self is not empty' do
    [' ', '　', 'string', '日本語'].each do |v|
      v.blank?.must_equal false
    end
  end
end

describe 'NilClass#blank?' do
  it 'should always return the true value' do
    nil.blank?.must_equal true
  end
end

describe 'OtherClasses#blank?' do
  it 'should always return the false value' do
    [0, 1, -1, 9.99, true, false, ::Time.now].each do |v|
      v.blank?.must_equal false
    end
  end  
end
