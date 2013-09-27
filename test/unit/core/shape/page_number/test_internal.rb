# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::PageNumber::TestInternal < MiniTest::Unit::TestCase
  include ThinReports::TestHelpers

  PageNumber = ThinReports::Core::Shape::PageNumber

  def init_pageno(format = {})
    PageNumber::Internal.new(flexmock('parent'), PageNumber::Format.new(format))
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

  def tset_build_format
    pageno = init_pageno('format' => '{page} / {total}')
    assert_equal pageno.build_format(1, 100), '1 / 100'

    pageno.write_format('{page}')
    assert_equal pageno.build_format(1, 100), '1'

    pageno = init_pageno('format' => '{page} / {total}', 
                         'start-at' => 5)
    assert_equal pageno.build_format(1, 100), '5 / 105'
  end

  def test_type_of
    pageno = init_pageno
    assert pageno.type_of?(:pageno)
  end

  def test_style
    pageno = init_pageno
    style = pageno.style

    assert_instance_of PageNumber::Style, style
    assert_same pageno.style, style
  end

  def test_Style_class
    refute_includes PageNumber::Style.accessible_styles, :valign
  end
end
