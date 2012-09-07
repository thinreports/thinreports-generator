# coding: utf-8

# Load thinreports
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/lib'))
require 'thinreports'

# Load tasks
Dir.glob('tasks/**/*.rake').each do |r|
  Rake.application.add_import r
end