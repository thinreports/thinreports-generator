# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::TestLayout < Minitest::Test
  include Thinreports::BasicReport::TestHelper

  def test_new
    assert_instance_of Thinreports::BasicReport::Layout::Base,
                       Thinreports::BasicReport::Layout.new(layout_file.path)
  end
end
