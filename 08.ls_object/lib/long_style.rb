# frozen_string_literal: true

class LongStyle
  MARGIN = 1
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
    nlink_width, uid_width, gid_width, file_size_width = width

    print_type(file)
    print_mode(file)
    print file.nlink.rjust(nlink_width), "\s"
    print file.uid.ljust(uid_width)
    print file.gid.ljust(gid_width)
    print file.size.rjust(file_size_width)
    print_timestamp(file)
    print file.path, "\n"
  end

  def print_total(files)
    blocks = files.sum { |file| file.stat.blocks }
    puts "total #{blocks}"
  end

  def width(files)
    width = []
    width << files.map { |file| file.nlink.length }.max
    width << files.map { |file| file.uid.length }.max + MARGIN
    width << files.map { |file| file.gid.length }.max + MARGIN
    width << files.map { |file| file.size.length }.max
  end

  def print_type(file)
    ftype = file.type
    case ftype
    when 'file'
      print '-'
    when 'fifo'
      print 'p'
    else
      print ftype[0]
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
      mode = file.mode[num]
      print mode.gsub(/[0-7]/, MODE_HASH)
    end
    print "\s"
  end

  def print_timestamp(file)
    format = within_half_a_year?(file) ? '%b %e %R ' : '%b %e  %Y '
    print file.mtime.strftime(format).to_s.rjust(STAMP_WIDTH)
  end

  def within_half_a_year?(file)
    (Date.today - file.mtime).abs <= HALF_A_YEAR
  end
end
