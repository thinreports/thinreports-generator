# frozen_string_literal: true

require 'pathname'

module Thinreports
  def self.root
    @root ||= Pathname.new(__FILE__).join('..', '..')
  end

  def self.generate(report_params, filename: nil)
    Generate.new.call(report_params, filename: filename)
  end
end

require_relative 'thinreports/version'
require_relative 'thinreports/config'
require_relative 'thinreports/core/utils'
require_relative 'thinreports/core/errors'
require_relative 'thinreports/core/format/base'
require_relative 'thinreports/core/shape'
require_relative 'thinreports/core/utils'
require_relative 'thinreports/report'
require_relative 'thinreports/layout'
require_relative 'thinreports/generator/pdf'
require_relative 'thinreports/generate'
