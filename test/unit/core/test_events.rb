# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::TestEvents < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers
  
  # Alias
  Events = ThinReports::Core::Events
  
  def setup
    @events = Events.new(:load, :change, :blur)
  end
  
  def test_listen
    load1_handler  = proc{|e| e.type }
    load2_handler  = proc{|e| e.type }
    change_handler = proc{|e| e.target }

    @events.listen(:load, &load1_handler)
    @events.listen(:change, &change_handler)
    # Overwrite
    @events.listen(:load, &load2_handler)
    
    # Using #on method
    @events.on(:blur) do |e|
      e.target
    end
    
    assert_equal @events.events.size, 3
    assert_same @events.events[:change], change_handler
    assert_same @events.events[:load], load2_handler
  end
  
  def test_listen_raise_error_when_unknown_event_type_is_set
    assert_raises ThinReports::Errors::UnknownEventType do
      @events.listen(:unknown) {|e| e.type }
    end
  end
  
  def test_listen_raise_error_when_no_block_is_given
    assert_raises ::ArgumentError do
      @events.listen(:blur)
    end
  end
  
  def test_unlisten
    @events.listen(:load) {|e| e.type }
    @events.listen(:change) {|e| e.type }
    @events.listen(:blur) {|e| e.type }
    
    @events.unlisten(:load)
    @events.un(:change)
    @events.un(:blur)
    
    assert_empty @events.events
  end
  
  def test_dispatch
    # Expected returns a true value
    @events.listen(:change) {|e| e.type == :change }
    assert_equal @events.dispatch(Events::Event.new(:change)), true
    
    # Expected to reverse the string given as e#target
    @events.on(:blur) {|e| e.target.reverse }
    assert_equal @events.dispatch(Events::Event.new(:blur, '123')), '321'
  end
  
  def test_dispatch_raise_error_when_no_event_type_is_given
    assert_raises ::ArgumentError do
      @events.dispatch(Events::Event.new)
    end
  end
  
  def test_dispatch_return_nil_when_event_type_is_not_listened
    assert_nil @events.dispatch(Events::Event.new(:load, self))
  end
  
  def test_copy
    @events.on(:change) {|e| e.type }
    @events.on(:load) {|e| e.type }
    
    copied = @events.copy
    
    assert_equal @events.events, copied.events
    refute_same  @events.events, copied.events
    
    @events.unlisten(:change)
    refute_nil copied.dispatch(Events::Event.new(:change, self))
  end
end