# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Style
        class Basic < Style::Base
          style_accessible :visible, :offset_x, :offset_y
          attr_accessor :visible

          style_accessor :offset_x, 'offset-x'
          style_accessor :offset_y, 'offset-y'

          def initialize(*args)
            super
            @visible = @format.display?
          end
        end
      end
    end
  end
end
