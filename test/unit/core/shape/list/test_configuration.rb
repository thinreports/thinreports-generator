# coding: utf-8

require 'test_helper'

class ThinReports::Core::Shape::List::TestConfiguration < Minitest::Test
  include ThinReports::TestHelper

  List = ThinReports::Core::Shape::List

  def setup
    @events = mock('events')
    @store  = mock('store')
    @config = List::Configuration.new
  end

  def test_use_stores
    List::Store.expects(:init).once

    @config.use_stores(a: 0, b: 0)
  end

  def test_store
    List::Store.expects(:init).returns(@store)

    @config.use_stores(a: 0, b: 0)
    assert_same @config.store, @store
  end

  def test_store_return_nil_when_uninitialized_yet
    assert_nil @config.store
  end

  def test_type
    assert_equal @config.type, List::TYPE_NAME
  end

  def test_copy
    copied_store = mock('copied store')

    @store.stubs(copy: copied_store)
    List::Store.expects(:init).returns(@store)

    copied_events = mock('copied events')

    @events.stubs(copy: copied_events)
    List::Events.expects(:new).returns(@events)

    @config = List::Configuration.new
    @config.use_stores(a: 1)

    copied_config = @config.copy

    assert_same copied_config.events, copied_events
    assert_same copied_config.store, copied_store
  end
end
