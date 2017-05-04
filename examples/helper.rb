require 'pathname'
require_relative '../lib/thinreports'

class Thinreports::Example
  ROOT = Pathname.new File.expand_path('..', __FILE__)

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
    path = ROOT.join @name.to_s
    filename ? path.join(filename).to_s : path.to_s
  end
end

def example(name, description = nil, &block)
  ex = Thinreports::Example.new(name, description)
  ex.start
  block.arity == 1 ? block.call(ex) : ex.instance_eval(&block)
  ex.success
rescue => e
  ex.error(e)
end
