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
    files.each do |file|
      show_content(file)
    end
  end

  private

  def show_content(file)
    print_type(file)
    print_mode(file)
    print File.stat(file).nlink.to_s.center(SMALL_WIDTH)
    print Etc.getpwuid(File.stat(file).uid).name.to_s.ljust(WIDTH)
    print Etc.getgrgid(File.stat(file).gid).name.to_s.ljust(WIDTH)
    print File.size(file).to_s.rjust(SMALL_WIDTH)
    print_timestamp(file)
    print file
    print "\n"
  end

  def print_total(files)
    blocks = files.sum { |file| File.stat(file).blocks }
    puts "total #{blocks}"
  end

  def print_type(file)
    type = File.ftype(file).to_s
    case type
    when 'file'
      print '-'
    when 'fifo'
      print 'p'
    else
      print type[0]
    end
  end

  MODE_HASH = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze


  def print_mode(file)
    (-3).upto(-1) do |num|
      mode = File.stat(file).mode.to_s(8)[num]
      print mode.gsub(/[0-7]/, MODE_HASH)
    end
  end

  def print_timestamp(file)
    format = within_half_a_year?(file) ? '%b %e %R ' : '%b %e  %Y '
    print File.mtime(file).strftime(format).to_s.rjust(BIG_WIDTH)
  end

  def within_half_a_year?(file)
    (Date.today - File.mtime(file).to_date).abs <= HALF_A_YEAR
  end
end
