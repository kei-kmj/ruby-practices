# frozen_string_literal: true

# ! /usr/bin/env ruby

require 'fileutils'

METACHARACTER = '*'
NUMBER_OF_COLUMNS = 3
BLANK = 3

def main
  (0...number_of_rows).each do |row|
    (0...NUMBER_OF_COLUMNS).each do |column|
      print_filename(row, column)
    end
    print "\n"
  end
end

def number_of_rows
  (number_of_files.to_f / NUMBER_OF_COLUMNS).ceil
end

def number_of_files
  Dir[METACHARACTER].length
end

def print_filename(row, column)
  name = filename(row, column)
  print name
  print add_space(name) if name
end

def filename(row, column)
  Dir[METACHARACTER][column * number_of_rows + row]
end

def add_space(name)
  ' ' * (max_character_count + BLANK - name.length)
end

def max_character_count
  Dir[METACHARACTER].max_by(&:length).length
end

main
