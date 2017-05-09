# frozen_string_literal: true

require 'test_helper'

class Thinreports::Layout::TestVersion < Minitest::Test
  include Thinreports::TestHelper

  # Alias
  Version = Thinreports::Layout::Version

  def test_compatible?
    Version.stubs(:compatible_rules).returns(['>= 0.8.0', '< 1.0.0'])

    assert Version.new('0.8.0').compatible?
    assert Version.new('0.9.9').compatible?
    assert Version.new('0.10.0').compatible?

    refute Version.new('0.7.9').compatible?
    refute Version.new('1.0.0').compatible?
  end

  def test_legacy?
    assert Version.new('0.8.9').legacy?
    refute Version.new('0.9.0').legacy?
  end
end
