# coding: utf-8

require 'thinreports'

class ThinReports::TestCase
  ROOTDIR = File.expand_path(File.join('test', 'case'))

  attr_reader :name, :description

  def initialize(name, description)
    @name = name
    @description = description
  end

  def start
    print "[#{name}] #{description}: "
  end

  def success
    print "ok#{$/}"
  end

  def error(e)
    puts "#{$/}ERROR: #{e}"
    puts e.backtrace
  end
  
  def layout_filename
    resource("#{@name}.tlf")
  end
  
  def output_filename
    resource("#{@name}.pdf")
  end
  
  def resource(filename = nil)
    File.join(*[ROOTDIR, @name.to_s, filename].compact)
  end
end

def testcase(name, description = nil, &block)
  test = ThinReports::TestCase.new(name, description)
  test.start
  block.arity == 1 ? block.call(test) : test.instance_eval(&block)
  test.success
rescue => e
  test.error(e)
end
