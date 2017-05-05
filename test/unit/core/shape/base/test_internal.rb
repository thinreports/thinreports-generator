# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Base::TestInternal < Minitest::Test
  include Thinreports::TestHelper

  def setup
    @report = Thinreports::Report.new layout: layout_file.path
    @report.start_new_page
  end

  def create_internal(format_config = {}, &block)
    format =
      unless format_config.empty?
        format_klass = Class.new(Thinreports::Core::Shape::Basic::Format) {
          config_reader(*format_config.keys.map {|k| k.to_sym })
        }
        format_klass.new(format_config)
      else
        Thinreports::Core::Shape::Basic::Format.new({})
      end

    klass = Class.new(Thinreports::Core::Shape::Base::Internal, &block)
    klass.new(@report.page, format)
  end

  def test_self_format_delegators_should_defines_method_delegated_from_format
    internal = create_internal('m1' => 'm1_value') {
      format_delegators :m1
    }
    assert_respond_to internal, :m1
  end

  def test_method_delegated_from_format_should_return_same_value_as_an_format
    internal = create_internal('m1' => 'm1 value') {
      format_delegators :m1
    }
    assert_same internal.m1, internal.format.m1
  end

  def test_copied_internal_should_have_the_new_value_specified_as_a_parent_property
    new_page = @report.start_new_page
    internal = create_internal {
      def style
        @style ||= Thinreports::Core::Shape::Style::Base.new(format)
      end
    }

    assert_same internal.copy(new_page).parent, new_page
  end

  def test_copied_internal_should_have_style_copied_from_original
    internal = create_internal {
      def style
        @style ||= Thinreports::Core::Shape::Style::Base.new(format)
      end
    }
    internal.style.write_internal_style(:foo, 'bar')
    new_internal = internal.copy(@report.start_new_page)

    assert_equal new_internal.style.read_internal_style(:foo), 'bar'
  end

  def test_copied_internal_should_have_states_property_copied_from_original
    internal = create_internal {
      def style
        @style ||= Thinreports::Core::Shape::Style::Base.new(format)
      end
    }
    internal.states[:foo] = 'bar'
    new_internal = internal.copy(@report.start_new_page)

    assert_equal new_internal.states[:foo], 'bar'
  end

  def test_copy_should_execute_block_with_new_internal_as_argument
    internal = create_internal {
      def style
        @style ||= Thinreports::Core::Shape::Style::Base.new(format)
      end
    }
    internal.copy(@report.start_new_page) do |new_internal|
      assert_equal new_internal.is_a?(Thinreports::Core::Shape::Base::Internal), true
    end
  end
end
