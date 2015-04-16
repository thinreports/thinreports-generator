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

  * Ruby 1.9.3, 2.0+
  * JRuby 1.7.0+ (1.9 mode)

## Getting Started

  * [Installation Guide](http://www.thinreports.org/documentation/getting-started/installation.html)
  * [Quick Start Guide](http://www.thinreports.org/documentation/getting-started/quickstart.html)
  * [Examples](https://github.com/thinreports/thinreports-examples)
  * [Rails4 Example](https://github.com/thinreports/thinreports-rails4-example)
  * [Discussion Group](https://groups.google.com/forum/#!forum/thinreports)
  * [![Join the chat at https://gitter.im/thinreports/thinreports-generator](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/thinreports/thinreports-generator?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Quick Reference

**NOTE:** You need to create a layout file `.tlf` using [Thinreports Editor](http://www.thinreports.org/features/editor/).

### Basic

```ruby
require 'thinreports'

report = Thinreports::Report.new layout: 'report.tlf'

report.start_new_page do
  item(:title).value('Thinreports')
end

report.start_new_page do |page|
  # Text block
  page.item(:text_block).value('Pure Ruby')

  # Image block
  page.item(:image_block).src('/path/to/image.png')
  require 'open-uri'
  page.item(:image_block).src(open('http://www.thinreports.org/assets/logos/thinreports-logo.png'))

  # Attributes
  page.item(:any).hide
  page.item(:any).show
  page.item(:any).visible(true)
  page.item(:any).visible? #=> true
  page.item(:any).id #=> "any"
  # Text block only
  page.item(:text_block).set('value', color: '#0000ff')
  page.item(:text_block).format_enabled(false)

  # Styles
  page.item(:title).style(:color, 'red')
  page.item(:rectangle).style(:border_color, '#ff0000')
                       .style(:border_width, 1)
                       .style(:fill_color, '#ffffff')
  page.item(:ellipse).styles(color: 'black', border_color: '#0000ff')
end

report.generate(filename: 'report.pdf')
```

```ruby
Thinreports::Report.generate(filename: 'report.pdf', layout: 'report.tlf') do |report|
  report.start_new_page do |page|
    page.item(:title).value('Thinreports')
  end

  page = start_new_page
  page.item(:title).value('Pure Ruby').style(:color, '#ff0000')
end
```

### List

```ruby
report = Thinreports::Report.new layout: 'list.tlf'

report.list.header do |header|
  header.item(:title).value('Title')
end

10.times do |n|
  report.list.add_row do |row|
    row.item(:no).value(n)
  end
end

report.generate(filename: 'list.tlf')
```

```ruby
report = Thinreports::Report.new layout: 'list_with_footer.tlf'

report.list do |list|
  total_price = 0
  price_per_page = 0

  list.on_page_finalize do
    total_price += price_per_page
    price_per_page = 0
  end

  list.on_page_footer_insert do |footer|
    footer.values price: price_per_page
  end

  list.on_footer_insert do |footer|
    footer.item(:price).value(total_price)
  end

  [100, 200, 300].each do |price|
    list.add_row price: price
    price_per_page += price
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

## Copyright

&copy; 2010-2015 [Matsukei Co.,Ltd](http://www.matsukei.co.jp).
