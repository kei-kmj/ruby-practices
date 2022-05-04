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

class FilesFactory
  attr_reader :files

  def initialize
    @files = Dispatch.new
    @option = Option.new
  end

  def set
    if @option.all?
      @files = @files.all
    else
      @files = @files.no_dots
    end

    if @option.reverse?
      @files = @files.reverse
    end
    @files
  end
end

class ListSegments
  NUMBER_OF_COLUMNS = 3

  def initialize
    @files = FilesFactory.new
  end

  def draw
    files = @files.set
    (0...number_of_rows(files)).each do |row|
      (0...NUMBER_OF_COLUMNS).each do |column|
        name = files[column * number_of_rows(files) + row]
        show_content(name)
      end
      print "\n"
    end
  end

  private

  def number_of_rows(files)
    (number_of_files(files).to_f / NUMBER_OF_COLUMNS).ceil
  end

  def number_of_files(files)
    files.length
  end

  def show_content(name)
    print name.ljust(20) if name
  end
end

ls = ListSegments.new
ls.draw