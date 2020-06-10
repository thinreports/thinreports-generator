# frozen_string_literal: true

require 'feature_test'

class TestDynamicStyle < FeatureTest
  feature :dynamic_style do
    image = path_of('image.png')
    setup_values = Proc.new do |page|
      # The Basic Style
      page.values(basic_show5: 'TextBlock',
                  basic_show6: image,
                  basic_hide5: 'TextBlock',
                  basic_hide6: image)
      # The Text Style
      page.values(text_b3: 'To bold',
                  text_b4: 'To normal',
                  text_i3: 'To italic',
                  text_i4: 'To normal',
                  text_u3: 'To underline',
                  text_u4: 'To none',
                  text_l3: 'To line-through',
                  text_l4: 'To none')
      page.values(text_a2: 'To right align',
                  text_a3: "To right align\n右寄せ",
                  text_va2: "To bottom align\n下揃え",
                  text_color2: '赤色')
    end

    report = Thinreports::Report.new layout: template_path('templates/styles.tlf')

    # Create raw-page.
    report.start_new_page
    report.page.item(:title).value('Original Page')

    setup_values.call(report.page)

    # Create styled-page.
    report.start_new_page

    setup_values.call(report.page)
    report.page.item(:title).value('Styled Page')

    # The Basic Style
    6.times do |i|
      report.page.item("basic_show#{i + 1}").style(:visible, true)
      report.page.item("basic_hide#{i + 1}").style(:visible, false)
    end

    # The Graphic Style
    report.page.item(:graphic_bcolor1).style(:border_color, '#ff0000')
    report.page[:graphic_bcolor2].style(:border_color, 'red')
    # nil or 'none'.
    report.page.item(:graphic_bcolor4).style(:border_color, nil)

    report.page.item(:graphic_bwidth1).style(:border_width, 5)
    report.page.item(:graphic_bwidth2).style(:border_width, 5)
    report.page.item(:graphic_bwidth3).style(:border_width, 5)
    report.page.item(:graphic_bwidth4).style(:border_width, 2)
    report.page.item(:graphic_bwidth5).style(:border_width, 0)

    report.page.item(:graphic_fcolor1).style(:fill_color, '#ff0000')
    # nil or 'none'
    report.page.item(:graphic_fcolor3).style(:fill_color, 'none')
    report.page.item(:graphic_fcolor4).style(:fill_color, 'ff0000')

    # The Text Style
    [1, 3].each do |i|
      report.page["text_b#{i}"].style(:bold, true)
      report.page.item("text_i#{i}").style(:italic, true)
      report.page.item("text_u#{i}").style(:underline, true)
      report.page.item("text_l#{i}").style(:linethrough, true)
    end
    [2, 4].each do |i|
      report.page.item("text_b#{i}").style(:bold, false)
      report.page.item("text_i#{i}").style(:italic, false)
      report.page.item("text_u#{i}").style(:underline, false)
      report.page.item("text_l#{i}").style(:linethrough, false)
    end

    3.times do |i|
      report.page.item("text_a#{i + 1}").style(:align, :right)
    end
    2.times do |i|
      report.page.item("text_va#{i + 1}").style(:valign, :bottom)
    end

    2.times do |i|
      report.page["text_color#{i + 1}"].style(:color, 'ff0000')
    end

    report.start_new_page(layout: template_path('templates/styles_in_list.tlf'))

    # Settings for Header.
    report.page.list(:list).header do |header|
      header.item(:rect).styles(border_color: nil,
                                fill_color: 'ff00ff')
      header.item(:text).styles(align: :center,
                                valign: :middle,
                                bold: true)
      header[:tblock].styles(align: :center,
                            valign: :middle,
                            color: 'red',
                            linethrough: true)
    end

    1.step(10, 1) do |i|
      # Flag of overflowed list-page.
      is_overflowed = report.page.list(:list).overflow?

      # Add details.
      report.page.list(:list).add_row do |row|
        case
        when i % 2 == 0
          row.item(:rect).styles(border_color: 'ff0000',
                                border_width: 3,
                                fill_color: '0000ff')
          row.item(:text).styles(color: 'red',
                                align: :left,
                                valign: :middle)
          row.item(:tblock).styles(color: 'blue',
                                  align: :left,
                                  valign: :middle)
        when i % 3 == 0
          row.item(:rect).style(:visible, false)
          row.item(:text).styles(color: '0000ff',
                                align: :right,
                                valign: :bottom)
          row.item(:tblock).styles(color: 'ff0000',
                                  align: :right,
                                  valign: :bottom)
        end
      end

      # Change header styles when list-page was overflowed.
      if is_overflowed
        report.page.list(:list).header do |header|
          header.item(:rect).styles(border_color: 'black',
                                    fill_color: '#ffffff')
          header.item(:text).styles(align: :left,
                                    valign: :top,
                                    bold: false)
          header.item(:tblock).styles(align: :left,
                                      valign: :top,
                                      color: '#000000',
                                      linethrough: false)
        end
      end
    end

    assert_pdf report.generate
  end
end
