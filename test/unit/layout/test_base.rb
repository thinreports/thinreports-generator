# frozen_string_literal: true

require 'test_helper'

class Thinreports::Layout::TestBase < Minitest::Test
  include Thinreports::TestHelper

  Layout = Thinreports::Layout

  def test_load_format
    assert_instance_of Layout::Format, Layout::Base.load_format(layout_file.path)
    assert_raises Thinreports::Errors::LayoutFileNotFound do
      Layout::Base.load_format 'unknown.tlf'
    end
  end

  def test_new
    layout_filename = layout_file.path
    layout = Layout::Base.new(layout_filename)

    assert_nil layout.id
    assert_equal layout_filename, layout.filename
    assert_instance_of Layout::Format, layout.format
  end

  def test_id
    layout_without_id = Layout::Base.new(layout_file.path)
    assert_nil layout_without_id.id

    layout_with_id = Layout::Base.new(layout_file.path, id: 'foo')
    assert_equal 'foo', layout_with_id.id
  end

  def test_default?
    layout_without_id = Layout::Base.new(layout_file.path)
    assert_equal true, layout_without_id.default?

    layout_with_id = Layout::Base.new(layout_file.path, id: 'bar')
    assert_equal false, layout_with_id.default?
  end
end
