# frozen_string_literal: true

require 'test_helper'

class Thinreports::TestLayout < Minitest::Test
  include Thinreports::TestHelper

  def test_new
    assert_instance_of Thinreports::Layout::Base,
                       Thinreports::Layout.new(layout_file.path)
  end
end
