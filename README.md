# Thinreports Generator [![Join the chat at https://gitter.im/thinreports/thinreports-generator](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/thinreports/thinreports-generator?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Gem Version](https://badge.fury.io/rb/thinreports.svg)](http://badge.fury.io/rb/thinreports)
[![](http://img.shields.io/travis/thinreports/thinreports-generator.svg?style=flat)](http://travis-ci.org/thinreports/thinreports-generator)
[![](http://img.shields.io/codeclimate/github/thinreports/thinreports-generator.svg?style=flat)](https://codeclimate.com/github/thinreports/thinreports-generator)
[![](http://img.shields.io/gemnasium/thinreports/thinreports-generator.svg?style=flat)](https://gemnasium.com/thinreports/thinreports-generator)

[Thinreports](http://www.thinreports.org) is an open source report generating tool for Ruby.

  * Thinreports Editor (GUI Designer)
  * Thinreports Generator (Report Generator for Ruby)

## Features

Features of Editor is [here](http://www.thinreports.org/features/editor/).

### Easy to generate PDF

Design layout using Editor, then embed values to text field in layout.

### Simple runtime environment

Ruby, RubyGems, Prawn and Generator.

### Dynamic operation

Generator can dynamically:

  * change value of TextBlock and ImageBlock
  * change style (border, fill, visibility, position, color, font) of Shape

### Others

  * External characters (Gaiji) for Japanese

## Supported Versions

  * Ruby 1.8.7,1.9.3, 2.0, 2.1, 2.2
  * JRuby 1.6, 1.7.0 (1.8 mode)

## Getting Started

  * [Installation Guide](http://www.thinreports.org/documentation/getting-started/installation.html)
  * [Quick Start Guide](http://www.thinreports.org/documentation/getting-started/quickstart.html)
  * [Examples](https://github.com/thinreports/thinreports-examples)
  * [Rails4 Example](https://github.com/thinreports/thinreports-rails4-example)
  * [Discussion Group](https://groups.google.com/forum/#!forum/thinreports)
  * [![Join the chat at https://gitter.im/thinreports/thinreports-generator](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/thinreports/thinreports-generator?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Quick Reference

**Note:** In order to use, you must need create layout file `.tlf` using [Thinreports Editor](http://www.thinreports.org/features/editor/).

### Basic format

```ruby
require 'thinreports'

report = ThinReports::Report.new :layout => 'report.tlf'
# Page 1
report.start_new_page do
  item(:title).value('Thinreports')
end

# Page 2
report.start_new_page do |page|
  page.item(:title).value('Pure Ruby')
  page.item(:title).style(:color, 'red')
end

report.generate(:filename => 'report.pdf')
```

```ruby
ThinReports::Report.generate(:filename => 'report.pdf', :layout => 'report.tlf') do
  start_new_page

  page.item(:title).value('Thinreports')

  start_new_page

  page.item(:title).value('Pure Ruby').style(:color, '#ff0000')
end
```

### List format

```ruby
report = ThinReports::Report.new :layout => 'list.tlf'
report.start_new_page

10.times do |n|
  report.list.add_row do |row|
    row.item(:no).value(n)
  end
end

report.generate(:filename => 'list.tlf')
```

```ruby
10.times do |n|
  report.list.add_row :no => n
end
```

```ruby
report.list(:other_list_id) do |list|
  10.times do |n|
    list.add_row :no => n
  end
end
```

  * `#start_new_page` can be omitted because it is created new page automatically when `#list` is called
  * id argument of `#list` can be omitted if is `:default`

0.7.0 and earlier:

```ruby
report = ThinReports::Report.new :layout => 'list.tlf'

10.times do |n|
  report.page.list(:default).add_row do |row|
    row.item(:no).value(n)
  end
end
```

[Learn more](http://www.thinreports.org/documentation/getting-started/quickstart.html).

## Contributing

### Report bug, post your suggestion

If you find bugs or improvements for the Editor, please report it [here](https://github.com/thinreports/thinreports-generator/issues/new).

### Sending a Pull Request

  1. Fork it
  2. Clone your forked repository
  3. Create your feature branch: `git checkout -b my-new-feature`
  4. Fix your feature
  5. Commit your changes: `git commit -am 'Fixed some bugs or features'`
  6. Push to the branch: `git push origin my-new-feature`
  7. Create new Pull Request

## License

Thinreports Generator is licensed under the [MIT-License](https://github.com/thinreports/thinreports-generator/blob/master/MIT-LICENSE).
Please see [LICENSE](https://github.com/thinreports/thinreports-generator/blob/master/LICENSE) for further details.

## Copyright

&copy; 2010-2015 Thinreports.org, sponsored by [Matsukei Corp](http://www.matsukei.co.jp).
