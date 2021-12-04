# frozen_string_literal: true

# ! /usr/bin/env ruby

require 'optparse'

NUMBER_OF_COLUMNS = 3
WIDTH = 25

def take_option
  option = {}
  opt = OptionParser.new
  opt.on('-r') { |reverse| option[:r] = reverse }
  opt.parse!(ARGV)
  { r: option[:r] }
end

def take_files
  option = take_option
  if option[:r]
    Dir.glob('*').reverse
  else
    Dir.glob('*')
  end
end

def main
  files = take_files
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
  print name.ljust(WIDTH) if name
end

main
