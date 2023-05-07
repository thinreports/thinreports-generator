# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::TestHiddenItemFeature < Thinreports::FeatureTest[__dir__]
  feature do
    report = Thinreports::BasicReport::Report.new layout: template_path
    2.times { report.list(:List).add_row }

    # In CI (GitHub Actions), the following error occurs rarely.
    #
    # > Error:.
    # > Thinreports::BasicReport::TestHiddenItemFeature#test_feature:.
    # > Errno::ENOENT: No such file or directory @ apply2files
    #
    # Probably GC related. It is not a fundamental solution,
    # but for now, the problem is reproduced only by CI, so we will deal with it by disabling GC.
    GC.disable

    assert_pdf report.generate
  ensure
    GC.enable
  end
end
