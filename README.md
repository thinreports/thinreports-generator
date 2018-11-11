# Thinreports Generator

[![Gem Version](https://badge.fury.io/rb/thinreports.svg)](http://badge.fury.io/rb/thinreports)
[![](http://img.shields.io/travis/thinreports/thinreports-generator.svg?style=flat)](http://travis-ci.org/thinreports/thinreports-generator)
[![Maintainability](https://api.codeclimate.com/v1/badges/054b400031608957ec4a/maintainability)](https://codeclimate.com/github/thinreports/thinreports-generator/maintainability)

[Thinreports](http://www.thinreports.org) is an open source report generating tool for Ruby.

  * Thinreports Editor (GUI Designer)
  * Thinreports Generator (Report Generator for Ruby)

## Getting Started

  * [Installation Guide](http://www.thinreports.org/documentation/getting-started/installation.html)
  * [Quick Start Guide](http://www.thinreports.org/documentation/getting-started/quickstart.html)
  * [Examples](https://github.com/thinreports/thinreports-examples)
  * [Rails5 Example](https://github.com/thinreports/thinreports-rails5-example)
  * [Changelog](https://github.com/thinreports/thinreports-generator/blob/master/CHANGELOG.md)
  * [Discussion Group](https://groups.google.com/forum/#!forum/thinreports)

## Supported versions

  * Ruby 2.1, 2.2, 2.3, 2.4, 2.5
  * JRuby 9.2

## Quick Reference

**NOTE:** You need to create a layout file `.tlf` using [Thinreports Editor](http://www.thinreports.org/features/editor/).

### Basic Objects and Basic Usage

```ruby
require 'thinreports'

report = Thinreports::Report.new layout: 'report.tlf'

report.start_new_page do
  item(:title).value('Thinreports')
end

report.start_new_page do |page|
  # Item Finder
  page.item(:item_id) # => Item object
  page[:item_id]      # => Item object

  # Text block
  page.item(:text_block).value('Pure Ruby')
  page.item(:text_block).value = 'Pure Ruby'
  page[:text_block] = 'Pure Ruby'
  page.item('text_block').set('value', color: '#0000ff')
  page.item(:text_block).format_enabled(false)

  # Image block
  page.item(:image_block).src('/path/to/image.png')
  page.item(:image_block).src = '/path/to/image.png'
  page[:image_block] = '/path/to/image.png'
  require 'open-uri'
  page.item(:image_block).src(open('http://www.thinreports.org/assets/logos/thinreports-logo.png'))

  # Attributes
  page.item(:any).hide
  page.item(:any).show
  page.item(:any).visible(true)
  page.item(:any).visible? # => true
  page.item(:any).id # => "any"

  # Styles
  page.item(:text).style(:color, 'red')
  page.item(:text).style(:bold, true)
  page.item(:text).style(:italic, true)
  page.item(:text).style(:linethrough, true)
  page.item(:text).style(:underline, true)
  page.item(:text).style(:font_size, 20)

  page.item(:text).style(:align, :left or :center or :right)
  page.item(:text).style(:valign, :top or :center or :bottom)

  page.item(:rectangle).style(:border_color, '#ff0000')
                       .style(:border_width, 1)
                       .style(:fill_color, '#ffffff')

  # Bulk setting of styles
  page.item(:text).styles(color: '#00000', align: :right)

  # Bulk setting of values
  page.values text_block_a: 'value', text_block_b: 'value'

  # Helpers
  page.item_exists?(:existing_id)  # => true
  page.item_exists?('existing_id') # => true
  page.item_exists?(:unknown_id)   # => false
end

report.generate(filename: 'report.pdf')
```

```ruby
Thinreports::Report.generate(filename: 'report.pdf', layout: 'report.tlf') do |report|
  report.start_new_page do |page|
    # :
  end
end
```

### Report and Page

```ruby
report = Thinreports::Report.new layout: 'foo.tlf'

3.times { report.start_new_page }

# Returns all pages
report.pages # => [<Report::Page>, <Report::Page>, <Report::Page>]
# Returns number of pages
report.page_count # => 3

# Add a blank page
report.add_blank_page

report.pages.last # => Report::BlankPage
```

### Using multiple layouts

```ruby
report = Thinreports::Report.new

report.use_layout '/path/to/default.tlf', default: true
report.use_layout '/path/to/other1.tlf', id: :other

report.start_new_page do |page|
  # use '/path/to/default.tlf' layout
end

report.start_new_page layout: :other do |page|
  # use '/path/to/other1.tlf' layout
end

report.start_new_page layout: '/path/to/other2.tlf' do |page|
  # use '/path/to/other2.tlf' layout
end
```

### Callbacks

```ruby
report = Thinreports::Report.new layout: 'foo.tlf'

# It will be called before finalizing each page
report.on_page_create do |page|
  page.item(:text).value('Text for all pages')
end
```

See also [features/report_callbacks](https://github.com/thinreports/thinreports-generator/tree/master/test/features/report_callbacks).

### List

```ruby
report = Thinreports::Report.new layout: 'list.tlf'

report.list.header do |header|
  header.item(:text_block).value('Title')
end

10.times do |n|
  report.list.add_row do |row|
    row.item(:text_block).value(n)
  end
end

report.generate(filename: 'list.pdf')
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
    list.add_row do |row|
      row[:price] = price
    end
    price_per_page += price
  end
end
```

See also  [features/list_events](https://github.com/thinreports/thinreports-generator/tree/master/test/features/list_events).

### Page Number

```ruby
# Setting starting number of page
report.start_page_number_from 5

# Setting whether to count new page
report.start_new_page count: true # default
report.start_new_page count: false

# Change styles
report.start_new_page do |page|
  page.item(:pageno).hide
  page.item(:pageno).show
  page.item(:pageno).visible(false)
  page.item(:pageno).styles(color: 'red', bold: true)
end
```

See also [features/page_number](https://github.com/thinreports/thinreports-generator/blob/master/test/features/page_number) and [features/page_number_with_list](https://github.com/thinreports/thinreports-generator/blob/master/test/features/page_number_with_list).

### Configuring fallback fonts

```ruby
Thinreports.configure do |config|
  config.fallback_fonts = '/path/to/fallback.ttf'
end

Thinreports.config.fallback_fonts = ['/path/to/font_a.ttf', '/path/to/font_b.ttf']
```

See also [features/eudc](https://github.com/thinreports/thinreports-generator/blob/master/test/features/eudc).

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
