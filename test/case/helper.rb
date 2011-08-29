# coding: utf-8

class ThinReports::TestCaseRunner
  ROOTDIR = File.expand_path(File.join('test', 'case'))
  
  class << self
    attr_accessor :current
    
    def current(casename)
      @current = casename.to_s
    end
    
    def layout_file
      case_file("#{@current}.tlf")
    end
    
    def output_file
      case_file("#{@current}.pdf")
    end
    
    def case_file(filename)
      File.join(ROOTDIR, @current, filename)
    end
  end
end

CaseRunner = ThinReports::TestCaseRunner