# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::Basic::TestInternal < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Basic = Thinreports::Core::Shape::Basic

  def create_internal(format_config = {})
    report = Thinreports::Report.new layout: layout_file.path

    Basic::Internal.new report.page, Basic::Format.new(format_config)
  end

  def test_id_should_operate_as_delegator_of_format
    basic = create_internal('id' => 'basic-id')
    assert_same basic.id, basic.format.id
  end

  def test_type_should_operate_as_delegator_of_format
    basic = create_internal('type' => 'ellipse')
    assert_same basic.type, basic.format.type
  end

  def test_style_should_return_instance_of_StyleGraphic
    assert_instance_of Thinreports::Core::Shape::Style::Graphic,
                       create_internal.style
  end

  def test_type_of_asker_should_already_return_true_when_the_specified_type_is_basic
    assert_equal create_internal.type_of?(:basic), true
  end

  def test_type_of_asker_should_return_true_when_the_specified_type_equal_self_type_name
    result = []

    result << create_internal('type' => 'rect').type_of?('rect')
    result << create_internal('type' => 'ellipse').type_of?('ellipse')
    result << create_internal('type' => 'line').type_of?('line')
    result << create_internal('type' => 'image').type_of?('image')

    assert_equal result.all?, true
  end

  def test_identifier
    basic = create_internal 'id' => 'basic-id'

    assert_equal 'basic-id', basic.identifier

    basic.style.stubs(identifier: 'style-identifier')
    assert_equal basic.identifier, 'basic-idstyle-identifier'
  end
end
