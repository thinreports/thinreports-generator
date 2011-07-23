# coding: utf-8

module ThinReports
  
  ROOTDIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
  
  module Core
  end
  
end

require 'thinreports/core/ext'
require 'thinreports/core/utils'
require 'thinreports/core/ordered_hash'

require 'thinreports/core/errors'
require 'thinreports/core/events'
require 'thinreports/core/format'
require 'thinreports/core/shape'
require 'thinreports/core/page'
