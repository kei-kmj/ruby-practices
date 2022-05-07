# frozen_string_literal: true

class LongStyle
  SMALL_WIDTH = 5
  WIDTH = 8
  BIG_WIDTH = 15
  HALF_A_YEAR = 182

  def initialize(option)
    @files = ExtractFiles.new option
  end

  def draw
    files = @files.extract
    print_total(files)
    (0...files.length).each do |n|
      name = files[n]
      show_content(name)
    end
  end

  private

  def show_content(name)
    print_type(name)
    print_mode(name)
    print File.stat(name).nlink.to_s.center(SMALL_WIDTH)
    print Etc.getpwuid(File.stat(name).uid).name.to_s.ljust(WIDTH)
    print Etc.getgrgid(File.stat(name).gid).name.to_s.ljust(WIDTH)
    print File.size(name).to_s.rjust(SMALL_WIDTH)
    print_timestamp(name)
    print name
    print "\n"
  end

  def print_total(files)
    blocks = (0...files.length).sum { |num| File.stat(files[num]).blocks }
    puts "total #{blocks}"
  end

  def print_type(name)
    type = File.ftype(name).to_s
    case type
    when 'file'
      print '-'
    when 'fifo'
      print 'p'
    else
      print type[0]
    end
  end

  def print_mode(name)
    (-3).upto(-1) do |num|
      mode = File.stat(name).mode.to_s(8)[num]
      print mode.gsub(/[0-7]/, '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', \
                               '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx')
    end
  end

  def print_timestamp(name)
    format = within_half_a_year?(name) ? '%b %e %R ' : '%b %e  %Y '
    print File.mtime(name).strftime(format).to_s.rjust(BIG_WIDTH)
  end

  def within_half_a_year?(name)
    (Date.today - File.mtime(name).to_date).abs <= HALF_A_YEAR
  end
end
