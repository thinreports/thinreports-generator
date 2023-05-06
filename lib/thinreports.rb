# frozen_string_literal: true

require 'pathname'

module Thinreports
  def self.root
    @root ||= Pathname.new(__FILE__).join('..', '..')
  end
end

require_relative 'thinreports/version'
require_relative 'thinreports/config'
require_relative 'thinreports/basic_report'
require_relative 'thinreports/section_report'
