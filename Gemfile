source 'http://rubygems.org'

gemspec

# In the case of Ruby 1.8.7.
unless RUBY_VERSION > '1.9'
  gem 'json', '>= 1.4.6'
  gem 'minitest', '>= 0'
  gem 'turn', '>=0'
end

platforms :mswin, :mingw do
  gem 'win32console'
end