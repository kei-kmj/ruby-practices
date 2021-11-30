# frozen_string_literal: true

# ! /usr/bin/env ruby

require 'optparse'

NUMBER_OF_COLUMNS = 3
BLANK = 3

def option
option = []
opt = OptionParser.new
opt.on('-a') { option << '-a' }
opt.parse!(ARGV)
end

files =
  if option.include?('-a')
    Dir.glob('*', File::FNM_DOTMATCH)
  else
    Dir.glob('*')
  end

def main(files)
  (0...number_of_rows(files)).each do |row|
    (0...NUMBER_OF_COLUMNS).each do |column|
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
  print name
  print add_space(name, files) if name
end

def add_space(name, files)
  ' ' * (files.max_by(&:length).length + BLANK - name.length)
end

main(files)
