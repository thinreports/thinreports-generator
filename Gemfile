# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem 'rake'
gem 'minitest'
gem 'mocha'
gem 'pdf-inspector'
gem 'matrix'
gem 'pdf_matcher-testing'

# suppress warning: assigned but unused variable - y1
# https://github.com/yob/pdf-reader/pull/502
gem 'pdf-reader', github: 'yob/pdf-reader', ref: 'dc7e6e46e1d842486bd34288df087b590e8a7b38'
