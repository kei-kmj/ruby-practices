# frozen_string_literal: true

class LongStyle
  MARGIN = 2
  STAMP_WIDTH = 14
  HALF_A_YEAR = 182

  def initialize(files)
    @files = files
  end

  def draw
    files = @files
    width = width(files)

    print_total(files)
    files.each do |file|
      show_content(file, width)
    end
  end

  private

  def show_content(file, width)
    nlink, uid, gid, file_size = content(file)
    nlink_width, uid_width, gid_width, file_size_width = width

    print_type(file)
    print_mode(file)
    print nlink.rjust(nlink_width), "\s"
    print uid.ljust(uid_width)
    print gid.ljust(gid_width)
    print file_size.rjust(file_size_width)
    print_timestamp(file)
    print file, "\n"
  end

  def content(file)
    content = []
    content << File.stat(file).nlink.to_s
    content << Etc.getpwuid(File.stat(file).uid).name.to_s
    content << Etc.getgrgid(File.stat(file).gid).name.to_s
    content << File.size(file).to_s
  end

  def print_total(files)
    blocks = files.sum { |file| File.stat(file).blocks }
    puts "total #{blocks}"
  end

  def width(files)
    width = []
    width << files.map { |file| content(file)[0].length }.max
    width << files.map { |file| content(file)[1].length }.max + MARGIN
    width << files.map { |file| content(file)[2].length }.max + MARGIN
    width << files.map { |file| content(file)[3].length }.max
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
