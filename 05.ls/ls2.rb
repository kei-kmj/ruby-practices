# frozen_string_literal: true

# ! /usr/bin/env ruby
require 'optparse'
require 'etc'
require 'date'

NLINK_WIDTH = 2
DETAIL_WIDTH = 5
TIMESTAMP_WIDTH = 15
HALF_A_YEAR = 182
MARGIN = 3

def option
  option = {}
  opt = OptionParser.new
  opt.on('-a') { |a| option[:all] = a }
  opt.on('-r') { |r| option[:reverse] = r }
  opt.on('-l') { |l| option[:line] = l }
  opt.order(ARGV)
  { all: option[:all], reverse: option[:reverse], line: option[:line] }
end

def all_files
  if option[:all]
    Dir.glob('*', File::FNM_DOTMATCH)
  else
    Dir.glob('*')
  end
end

def take_files
  if option[:reverse]
    all_files.reverse
  else
    all_files
  end
end

def main
  files = take_files
  print_total(files) if option[:line]
  (0...number_of_rows(files)).each do |row|
    (0...number_of_columns).each do |column|
      name = files[column * number_of_rows(files) + row]
      show_content(name)
    end
    print "\n"
  end
end

def print_total(files)
  blocks = (0...number_of_files(files)).sum { |num| File.stat(files[num]).blocks }
  puts "total #{blocks}"
end

def number_of_rows(files)
  (number_of_files(files).to_f / number_of_columns).ceil
end

def number_of_files(files)
  files.length
end

def number_of_columns
  option[:line] ? 1 : 3
end

def show_content(name)
  print_file_detail(name) if option[:line]
  print name.ljust(margin_of_filename) if name
end

def print_file_detail(name)
  return unless name

  print_type(name)
  print_mode(name)
  print File.stat(name).nlink.to_s.rjust(NLINK_WIDTH)
  print Etc.getpwuid(File.stat(name).uid).name.to_s.rjust(DETAIL_WIDTH)
  print Etc.getgrgid(File.stat(name).gid).name.to_s.rjust(DETAIL_WIDTH)
  print File.size(name).to_s.rjust(DETAIL_WIDTH)
  print_timestamp(name)
end

def print_type(name)
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

def print_mode(name)
  (-3).upto(-1) do |num|
    mode = File.stat(name).mode.to_s(8)[num]
    print mode.gsub(/[0-7]/, '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',\
                             '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx')
  end
end

def print_timestamp(name)
  format = within_half_a_year?(name) ? '%b %e %R ' : '%b %e  %Y '
  print File.mtime(name).strftime(format).to_s.rjust(TIMESTAMP_WIDTH)
end

def within_half_a_year?(name)
  (Date.today - File.mtime(name).to_date).abs <= HALF_A_YEAR
end

def margin_of_filename
  take_files.max_by(&:length).length + MARGIN
end

main
