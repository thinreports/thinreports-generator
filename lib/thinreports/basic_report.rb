# frozen_string_literal: true

require_relative 'basic_report/core/utils'
require_relative 'basic_report/core/errors'
require_relative 'basic_report/core/format/base'
require_relative 'basic_report/core/shape'
require_relative 'basic_report/core/utils'
require_relative 'basic_report/report'
require_relative 'basic_report/layout'
require_relative 'basic_report/generator/pdf'

module Thinreports
  Report = BasicReport::Report
  Layout = BasicReport::Layout
end
