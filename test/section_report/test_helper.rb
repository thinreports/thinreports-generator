# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/unit'
require 'mocha/minitest'

require 'thinreports'
require 'feature_test'

Mocha.configure do |c|
  c.strict_keyword_argument_matching = true
end
