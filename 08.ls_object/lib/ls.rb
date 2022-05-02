require 'optparse'
require 'etc'
require 'date'

class Option

  def initialize
    option = ARGV.getopts('a', 'l', 'r')
    @all = option['a']
    @line = option['l']
    @reverse = option['r']
  end

  def all?
    @all
  end

  def line?
    @line
  end

  def reverse?
    @reverse
  end
end

class Dispatch
  attr_reader :files

  def initialize
    @files = files
  end

  def all
    @files = Dir.glob('*', File::FNM_DOTMATCH)
  end

  def no_dots
    @files = Dir.glob('*')
  end

  def reverse
    @files.reverse
  end
end

class God
  attr_reader :files

  def initialize
    @files = Dispatch.new
    @option = Option.new
  end

  def get_files
    if @option.all?
      @files = @files.all
    else
      @files = @files.no_dots
    end

    if @option.reverse?
      @files = @files.reverse
    end
    puts @files
  end
end

god = God.new
god.get_files