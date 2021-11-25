# frozen_string_literal: true

# ! /usr/bin/env ruby

require 'fileutils'
require 'optparse'
opt = OptionParser.new
opt.on('-a')
params = {}
opt.parse!(ARGV, into: params)
p params[:a]

def files(params)
  Dir['.*', '*'] if params[:a]
end

NUMBER_OF_COLUMNS = 3
BLANK = 3
NUMBER_OF_FILES = files(params).length
NUMBER_OF_ROWS =  (NUMBER_OF_FILES.to_f / NUMBER_OF_COLUMNS).ceil

def main(params)
  (0...NUMBER_OF_ROWS).each do |row|
    (0...NUMBER_OF_COLUMNS).each do |column|
      print_filename(row, column, params)
    end
    print "\n"
  end
end

def print_filename(row, column, params)
  name = filename(row, column, params)
  print name
  print add_space(name, params) if name
end

def filename(row, column, params)
  files(params)[column * NUMBER_OF_ROWS + row]
end

def add_space(name, params)
  ' ' * (max_character_count(params) + BLANK - name.length)
end

def max_character_count(params)
  files(params).max_by(&:length).length
end

main(params)
