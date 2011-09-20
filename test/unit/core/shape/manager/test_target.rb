# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::Manager::TestTarget < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Shape = ThinReports::Core::Shape
  
  class TestFormat < Shape::Manager::Format; end
  
  class TestManager
    include Shape::Manager::Target
    
    def initialize(format)
      initialize_manager(format) do |f|
        Shape::Interface(self, f)
      end
    end
  end
  
  def setup
    tblock1_format = Shape::TextBlock::Format.new('id'   => 'tblock1',
                                                  'type' => 's-tblock')
    tblock2_format = Shape::TextBlock::Format.new('id'   => 'tblock2',
                                                  'type' => 's-tblock')
    list_format    = Shape::List::Format.new('id' => 'list',
                                             'type' => 's-list')
    
    @format = TestFormat.new({}) do |f|
      f.shapes[:tblock1] = tblock1_format
      f.shapes[:tblock2] = tblock2_format
      f.shapes[:list]    = list_format
    end
    @manager = TestManager.new(@format)
  end
  
  def test_item_with_Symbol_id
    assert_instance_of Shape::TextBlock::Interface, @manager.item(:tblock1)
  end
  
  def test_item_with_String_id
    assert_instance_of Shape::TextBlock::Interface, @manager.item('tblock1')
  end
  
  def test_item_raise_error_when_given_the_id_of_list
    assert_raises ThinReports::Errors::UnknownItemId do
      @manager.item(:list)
    end
  end
  
  def test_item_raise_error_when_given_the_unknown_id
    assert_raises ThinReports::Errors::UnknownItemId do
      @manager.item(:unknown)
    end
  end
  
  def test_item_with_block_that_has_no_arguments
    @manager.item(:tblock1) do
      value(1000)
    end
    assert_equal @manager.item(:tblock1).value, 1000
  end
  
  def test_item_with_block_that_has_an_argument
    @manager.item(:tblock2) do |t|
      t.value(1000)
    end
    assert_equal @manager.item(:tblock2).value, 1000
  end
  
  def test_list_raise_error_when_given_id_of_non_list
    assert_raises ThinReports::Errors::UnknownItemId do
      @manager.list(:tblock1)
    end
  end
  
  def test_list_should_be_stored_in_the_special_store
    flexmock(@manager).
      should_receive(:find_item).and_return(flexmock('item_list'))
    
    @manager.list(:list)
    assert_includes @manager.manager.lists, :list
  end
  
  def test_items_should_be_warned_as_deprecated
    out, err = capture_io do
      @manager.items :tblock1 => 1000
    end
    assert_match %r!DEPRECATION!, err
  end
  
  def test_values
    @manager.values :tblock1 => 1000,
                    :tblock2 => 2000
    
    assert_equal @manager.item(:tblock1).value, 1000
  end
  
  def test_values_should_properly_set_to_ImageBlock
    @format.shapes[:image] = Shape::ImageBlock::Format.new({'id'   => 'image',
                                                            'type' => 's-iblock'})
    @manager.values(:image => '/path/to/image.png')
    
    assert_equal @manager.item(:image).src, '/path/to/image.png'
  end
  
  def test_item_exists?
    assert_equal @manager.item_exists?(:tblock1), true
    assert_equal @manager.item_exists?('list'), true
    assert_equal @manager.item_exists?(:unknown), false
    # Alias method
    assert_equal @manager.exists?(:tblock1), true
  end
end