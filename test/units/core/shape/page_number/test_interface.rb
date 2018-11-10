# frozen_string_literal: true

require 'test_helper'

class Thinreports::Core::Shape::PageNumber::TestInterface < Minitest::Test
  include Thinreports::TestHelper

  PageNumber = Thinreports::Core::Shape::PageNumber

  def create_pageno(format = {})
    report = Thinreports::Report.new layout: layout_file.path
    parent = report.start_new_page

    PageNumber::Interface.new parent, PageNumber::Format.new(format)
  end

  def test_format
    pageno = create_pageno 'format' => '{page}'

    assert_equal pageno.format, '{page}'
    pageno.format('{page} / {total}')
    assert_equal pageno.format, '{page} / {total}'
  end

  def test_reset_format
    pageno = create_pageno 'format' => '{page}'

    pageno.format('-- {page} --')
    pageno.reset_format

    assert_equal pageno.format, '{page}'
  end
end
