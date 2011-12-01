# coding: utf-8

require 'thinreports'

class ThinReports::TestCaseRunner
  ROOTDIR = File.expand_path(File.join('test', 'case'))
  
  class << self
    attr_accessor :current
    
    def current(casename)
      @current = casename.to_s
    end
    
    def layout_file
      case_resource("#{@current}.tlf")
    end
    
    def output_file
      case_resource("#{@current}.pdf")
    end
    
    def case_resource(filename = nil)
      File.join(*[ROOTDIR, @current, filename].compact)
    end
  end
end

CaseRunner = ThinReports::TestCaseRunner