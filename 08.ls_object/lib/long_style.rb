# frozen_string_literal: true

class LongStyle
  STAMP_WIDTH = 14
  HALF_A_YEAR = 182

  def initialize(option)
    @files = ExtractFiles.new option
  end

  def draw
    files = @files.extract
    width = width(files)

    print_total(files)
    files.each do |file|
      show_content(file,width)
    end
  end

  private

  def show_content(file,width)
    print_type(file)
    print_mode(file)
    print File.stat(file).nlink.to_s.rjust(width[0]), "\s"
    print Etc.getpwuid(File.stat(file).uid).name.to_s.ljust(width[1])
    print Etc.getgrgid(File.stat(file).gid).name.to_s.ljust(width[2])
    print File.size(file).to_s.rjust(width[3])
    print_timestamp(file)
    print file
    print "\n"
  end

  def print_total(files)
    blocks = files.sum { |file| File.stat(file).blocks }
    puts "total #{blocks}"
  end
  MARGIN = 2
  def width(files)
    width = []
    width << files.map {|file| File.stat(file).nlink.to_s.length}.max
    width << files.max {|file| Etc.getpwuid(File.stat(file).uid).name.length}.length + MARGIN
    width << files.max {|file| Etc.getgrgid(File.stat(file).gid).name.length}.length + MARGIN
    width << files.map {|file| File.size(file).to_s.length}.max
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
    print "\s"
  end

  def print_timestamp(file)
    format = within_half_a_year?(file) ? '%b %e %R ' : '%b %e  %Y '
    print File.mtime(file).strftime(format).to_s.rjust(STAMP_WIDTH)
  end

  def within_half_a_year?(file)
    (Date.today - File.mtime(file).to_date).abs <= HALF_A_YEAR
  end
end
