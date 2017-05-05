# frozen_string_literal: true

module Thinreports
  module Core
    module Shape
      module Style
        class Basic < Style::Base
          style_accessible :visible
          attr_accessor :visible

          def initialize(*args)
            super
            @visible = @format.display?
          end
        end
      end
    end
  end
end
