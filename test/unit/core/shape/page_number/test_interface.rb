# coding: utf-8

require 'test/unit/helper'

class ThinReports::Core::Shape::PageNumber::TestInterface < Minitest::Test
  include ThinReports::TestHelpers

  PageNumber = ThinReports::Core::Shape::PageNumber

  def init_pageno(format = {})
    PageNumber::Interface.new(flexmock('parent'), PageNumber::Format.new(format))
  end

  def test_format
    pageno = init_pageno('format' => '{page}')

    assert_equal pageno.format, '{page}'
    pageno.format('{page} / {total}')
    assert_equal pageno.format, '{page} / {total}'
  end

  def test_reset_format
    pageno = init_pageno('format' => '{page}')

    pageno.format('-- {page} --')
    pageno.reset_format

    assert_equal pageno.format, '{page}'
  end
end
