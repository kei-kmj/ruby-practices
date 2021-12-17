# frozen_string_literal: true

# ! /usr/bin/env ruby
require 'optparse'
require 'etc'
require 'date'

NUMBER_OF_COLUMNS = 1
FILENAME_WIDTH = 25
NLINK_WIDTH = 2
DETAIL_WIDTH = 5
TIMESTAMP_WIDTH = 15
HALF_A_YEAR = 182

def option
  option = {}
  opt = OptionParser.new
  opt.on('-l') { |liner| option[:line] = liner }
  opt.parse(ARGV)
  { line: option[:line] }
end

def take_files
  Dir.glob('*')
end

def main
  files = take_files
  print_total(files)
  (0...number_of_files(files)).each do |row|
    (0...NUMBER_OF_COLUMNS).each do |column|
      file_detail(row, column, files) if option[:line]
      print_filename(row, column, files)
    end
    print "\n"
  end
end

def number_of_rows(files)
  (number_of_files(files).to_f / NUMBER_OF_COLUMNS).ceil
end

def number_of_files(files)
  files.length
end

def print_filename(row, column, files)
  name = files[column * number_of_rows(files) + row]
  print name.ljust(FILENAME_WIDTH) if name
end

def print_total(files)
  blocks = 0
  (0...number_of_files(files)).sum do |num|
    blocks += File.stat(files[num]).blocks
  end
  puts "total #{blocks}"
end

def print_type(row, column, files)
  name = files[column * number_of_rows(files) + row]
  type = File.ftype(name).to_s
  case type
  when type == 'file'
    print '-'
  when type == 'fifo'
    print 'p'
  else
    print File.ftype(name).to_s[0]
  end
end

def print_mode(row, column, files)
  name = files[column * number_of_rows(files) + row]
  (-3).upto(-1) do |num|
    mode = File.stat(name).mode.to_s(8)[num]
    print mode.gsub(/0|1|2|3|4|5|6|7/, '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',\
                                       '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx')
  end
end

def file_detail(row, column, files)
  name = files[column * number_of_rows(files) + row]
  return unless name

  print_type(row, column, files)
  print_mode(row, column, files)
  print File.stat(name).nlink.to_s.rjust(NLINK_WIDTH)
  print Etc.getpwuid(File.stat(name).gid).name.to_s.rjust(DETAIL_WIDTH)
  print Etc.getgrgid(File.stat(name).uid).name.to_s.rjust(DETAIL_WIDTH)
  print File.size(name).to_s.rjust(DETAIL_WIDTH)
  print_timestamp(row, column, files)
end

def print_timestamp(row, column, files)
  name = files[column * number_of_rows(files) + row]
  difference = days_difference(name)
  format = difference <= HALF_A_YEAR ? '%b %e %R ' : '%b %e  %Y '
  print File.mtime(name).strftime(format).to_s.rjust(TIMESTAMP_WIDTH)
end

def days_difference(name)
  (Date.today - File.mtime(name).to_date).abs
end

main
