# coding: utf-8

module Thinreports
  ROOT = File.expand_path File.join(File.dirname(__FILE__), '..')
end

require 'thinreports/version'
require 'thinreports/config'
require 'thinreports/core/utils'
require 'thinreports/core/errors'
require 'thinreports/core/format/base'
require 'thinreports/core/shape'
require 'thinreports/core/utils'
require 'thinreports/report'
require 'thinreports/layout'
require 'thinreports/generator/pdf'

# Alias for Thinreports
ThinReports = Thinreports
class Object
  deprecate_constant :ThinReports
end if Object.respond_to?(:deprecate_constant)
