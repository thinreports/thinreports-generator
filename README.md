# Thinreports Generator

[![Gem Version](https://badge.fury.io/rb/thinreports.svg)](http://badge.fury.io/rb/thinreports)
[![Test](https://github.com/thinreports/thinreports-generator/workflows/Test/badge.svg)](https://github.com/thinreports/thinreports-generator/actions)

A Ruby library for [Thinreports](https://github.com/thinreports/thinreports).

## Prerequisites

### Supported Versions

- Ruby 2.5, 2.6, 2.7, 3.0
- JRuby 9.2
- Prawn 2.2, 2.3, 2.4

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thinreports'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install thinreports


## Getting Started

First of all, check out [the README](https://github.com/thinreports/thinreports#getting-started) for an overview of Thinreports, its features, the two template formats available, and a complete example with template files and Ruby code.

## Usage

See [the README](https://github.com/thinreports/thinreports) for usage of the Section Format.

### Basic Format

The template file (`.tlf`) must be created in the [Thinreports Basic Editor](https://github.com/thinreports/thinreports-basic-editor/).

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

#### Report and Page

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

#### Using multiple layouts

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

#### Callbacks

```ruby
report = Thinreports::Report.new layout: 'foo.tlf'

# It will be called before finalizing each page
report.on_page_create do |page|
  page.item(:text).value('Text for all pages')
end
```

See also [features/report_callbacks](https://github.com/thinreports/thinreports-generator/tree/master/test/features/report_callbacks).

#### List

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

#### Page Number

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

#### Configuring fallback fonts

```ruby
Thinreports.configure do |config|
  config.fallback_fonts = '/path/to/fallback.ttf'
end

Thinreports.config.fallback_fonts = ['/path/to/font_a.ttf', '/path/to/font_b.ttf']
```

See also [features/eudc](https://github.com/thinreports/thinreports-generator/blob/master/test/features/eudc).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thinreports/thinreports-generator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/thinreports/thinreports/blob/master/CODE_OF_CONDUCT.md).

## Development

### How to run feature tests

```
$ bundle exec rake test:features
```

In order to run `test:features`, you need to install [diff-pdf](https://github.com/vslavik/diff-pdf) in your environment, or you can run test in the docker container as below.

### How to develop in Docker container

You can use the Docker container for development. This container contains the libraries required for testing, such as diff-pdf.

```
$ docker pull ghcr.io/hidakatsuya/ruby-with-diff-pdf:latest
$ docker run -v $PWD:/src:cached -it ghcr.io/hidakatsuya/ruby-with-diff-pdf bash

> /src#
```

You can run test:

```
> /src# bundle install
> /src# bundle exec rake test:features
```

## Releasing Generator

1. Update the version number in `version.rb`
2. Update `CHANGELOG.md` and `README.md` (if needed)
3. Create the Release PR like #105
4. Merge the PR
5. Is the master CI green? If not, make it green
6. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to rubygems.org

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Copyright

(c) 2021 [Matsukei Co.,Ltd](http://www.matsukei.co.jp).
