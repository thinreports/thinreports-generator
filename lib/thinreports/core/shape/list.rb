# coding: utf-8

module ThinReports
  module Core::Shape
    
    module List
      TYPE_NAME = 's-list'
    end
    
  end
end

require 'thinreports/core/shape/list/format'
require 'thinreports/core/shape/list/manager'

require 'thinreports/core/shape/list/page'
require 'thinreports/core/shape/list/page_state'

require 'thinreports/core/shape/list/section_format'
require 'thinreports/core/shape/list/section_interface'
require 'thinreports/core/shape/list/section_internal'

require 'thinreports/core/shape/list/store'
require 'thinreports/core/shape/list/events'
require 'thinreports/core/shape/list/configuration'