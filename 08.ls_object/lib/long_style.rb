# frozen_string_literal: true

class LongStyle
  MARGIN = 1
  HALF_A_YEAR = 182

  def initialize(files)
    @files = files
  end

  def draw
    files = @files
    width = calc_width(files)

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
    print file.nlink.to_s.rjust(nlink_width), "\s"
    print file.uid.name.ljust(uid_width)
    print file.gid.name.ljust(gid_width)
    print file.size.to_s.rjust(file_size_width), "\s"
    print_timestamp(file)
    print file.path, "\n"
  end

  def print_total(files)
    blocks = files.sum { |file| file.stat.blocks }
    puts "total #{blocks}"
  end

  def calc_width(files)
    width = []
    width << files.map { |file| file.nlink.to_s.length }.max
    width << files.map { |file| file.uid.name.length }.max + MARGIN
    width << files.map { |file| file.gid.name.length }.max + MARGIN
    width << files.map { |file| file.size.to_s.length }.max
    width
  end

  def print_type(file)
    ftype = file.ftype
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
      mode = file.mode.to_s(8)[num]
      print mode.gsub(/[0-7]/, MODE_HASH)
    end
    print "\s"
  end

  def print_timestamp(file)
    format = within_half_a_year?(file) ? '%b %e %R ' : '%b %e  %Y '
    print file.mtime.strftime(format)
  end

  def within_half_a_year?(file)
    (Date.today - file.mtime.to_date).abs <= HALF_A_YEAR
  end
end
