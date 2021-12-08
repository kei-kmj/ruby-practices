# frozen_string_literal: true

# ! /usr/bin/env ruby
require 'optparse'
require 'etc'
require 'date'

NUMBER_OF_COLUMNS = 1
WIDTH = 25

def take_option
  option = {}
  opt = OptionParser.new
  opt.on('-l') { |liner| option[:l] = liner }
  opt.parse!(ARGV)
  { l: option[:l] }
end

def take_files
  Dir.glob('*')
end

def main
  files = take_files
  option = take_option
  if option[:l]
    total(files)
    (0...number_of_files(files)).each do |row|
      (0...NUMBER_OF_COLUMNS).each do |column|
        file_detail(row, column, files)
        print_filename(row, column, files)
      end
      print "\n"
    end
  else
    (0...number_of_rows(files)).each do |row|
      (0...NUMBER_OF_COLUMNS).each do |column|
        print_filename(row, column, files)
      end
      print "\n"
    end
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
  print name.ljust(WIDTH) if name
end

def total(files)
  blocks = 0
  (0...number_of_rows(files)).each do |row|
    (0...NUMBER_OF_COLUMNS).each do |column|
      name = files[column * number_of_rows(files) + row]
      blocks += File.stat(name).blocks
    end
  end
  puts blocks
end

 def file_type(row, column, files)
  name = files[column * number_of_rows(files) + row]
  type = File.ftype(name).to_s
  if type == 'file'
    print '-'
  elsif type == 'fifo'
    print 'p'
  else
    print File.ftype(name).to_s[0]
  end
 end

def file_mode(row, column, files)
  name = files[column * number_of_rows(files) + row]
  (-3).upto(-1) do |i|
    mode = File.stat(name).mode.to_s(8)[i]
    print mode.gsub(/0|1|2|3|4|5|6|7/, '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',\
                                       '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx')
  end
end

def file_detail(row, column, files)
  name = files[column * number_of_rows(files) + row]
  file_type(row, column, files)
  file_mode(row, column, files)
  print File.stat(name).nlink.to_s.rjust(5) if name
  print Etc.getpwuid(File.stat(name).gid).name.to_s.rjust(5) if name
  print Etc.getgrgid(File.stat(name).uid).name.to_s.rjust(5) if name
  print File.size(name).to_s.rjust(5) if name
  timestamp(row, column, files)
end

def timestamp(row, column, files)
  name = files[column * number_of_rows(files) + row]
  if (Date.today - File.mtime(name).to_date).abs <= 182
    print File.mtime(name).strftime('%b %e %R ').to_s.rjust(15) if name
  else
    print File.mtime(name).strftime('%b %e  %Y ').to_s.rjust(15)
  end
end
main
