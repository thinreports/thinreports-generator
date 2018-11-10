# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::PageNumber::TestInternal < Minitest::Test
  include Thinreports::TestHelper

  PageNumber = Thinreports::Core::Shape::PageNumber

  def setup
    @report = Thinreports::Report.new layout: layout_file.path
    @report.start_new_page
  end

  def init_pageno(format = {})
    PageNumber::Internal.new(@report.page, PageNumber::Format.new(format))
  end

  def test_read_format
    pageno = init_pageno('format' => 'Page {page}')

    assert_equal pageno.read_format, 'Page {page}'
  end

  def test_write_format
    pageno = init_pageno('format' => 'Page {page}')
    pageno.write_format('{page}')

    assert_equal pageno.read_format, '{page}'
  end

  def test_reset_format
    pageno = init_pageno('format' => '{page}')
    pageno.write_format('Page {page}')
    pageno.reset_format

    assert_equal pageno.read_format, '{page}'
  end

  def test_build_format
    pageno = init_pageno('format' => '{page} / {total}')
    assert_equal pageno.build_format(1, 100), '1 / 100'

    pageno.write_format('{page}')
    assert_equal pageno.build_format(1, 100), '1'

    @report.start_page_number_from 5
    pageno = init_pageno('format' => '{page} / {total}')
    assert_equal pageno.build_format(1, 100), '5 / 104'

    # if counted target is a List shape
    pageno = init_pageno('format' => '{page} / {total}',
                         'target' => 'list-id')
    assert_equal pageno.build_format(1, 100), '1 / 100'
  end

  def test_type_of
    pageno = init_pageno
    assert pageno.type_of?('page-number')
  end

  def test_style
    pageno = init_pageno
    style = pageno.style

    assert_instance_of PageNumber::Style, style
    assert_same pageno.style, style
  end

  def test_for_report
    pageno = init_pageno('target' => '')
    assert_equal pageno.for_report?, true

    pageno = init_pageno('target' => 'list-id')
    assert_equal pageno.for_report?, false
  end

  def test_Style_class
    refute_includes PageNumber::Style.accessible_styles, :valign
  end
end
