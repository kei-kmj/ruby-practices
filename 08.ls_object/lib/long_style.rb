# frozen_string_literal: true

class LongStyle
  MARGIN = 1
  HALF_A_YEAR = 182

  def initialize(files)
    @files = files
  end

  def draw
    width = calc_width

    print_total
    @files.each do |file|
      print_content(file, width)
    end
  end

  private

  def print_content(file, width)
    print type(file)
    print mode(file)
    print file.nlink.to_s.rjust(width[:nlink]), "\s"
    print file.user_name.ljust(width[:uid])
    print file.group_name.ljust(width[:gid])
    print file.size.to_s.rjust(width[:file_size]), "\s"
    print timestamp(file)
    puts file.path
  end

  def print_total
    blocks = @files.sum { |file| file.blocks }
    puts "total #{blocks}"
  end

  def calc_width
    { nlink: @files.map { |file| file.nlink.to_s.length }.max,
      uid: @files.map { |file| file.user_name.length }.max + MARGIN,
      gid: @files.map { |file| file.group_name.length }.max + MARGIN,
      file_size: @files.map { |file| file.size.to_s.length }.max }
  end

  def type(file)
    ftype = file.ftype
    case ftype
    when 'file'
      '-'
    when 'fifo'
      'p'
    else
      ftype[0]
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

  def mode(file)
    (-3).upto(-1) do |num|
      mode = file.mode.to_s(8)[num]
      print mode.gsub(/[0-7]/, MODE_HASH)
    end
    "\s"
  end

  def timestamp(file)
    format = within_half_a_year?(file) ? '%b %e %R ' : '%b %e  %Y '
    file.mtime.strftime(format)
  end

  def within_half_a_year?(file)
    (Date.today - file.mtime.to_date).abs <= HALF_A_YEAR
  end
end
