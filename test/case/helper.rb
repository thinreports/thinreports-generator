# coding: utf-8

class ThinReports::TestCaseRunner
  ROOTDIR = File.expand_path(File.join('test', 'case'))
  
  class << self
    attr_accessor :current
    
    def current(casename)
      @current = casename.to_s
    end
    
    def layout_file
      File.join(ROOTDIR, @current, "#{@current}.tlf")
    end
    
    def output_file
      File.join(ROOTDIR, @current, "#{@current}.pdf")
    end
  end
end

CaseRunner = ThinReports::TestCaseRunner