# frozen_string_literal: true

# ! /usr/bin/env ruby

require 'fileutils'

METACHARACTER = '*'
NUMBER_OF_FILES = Dir[METACHARACTER].length
NUMBER_OF_COLUMNS = 3
NUMBER_OF_ROWS = (NUMBER_OF_FILES.to_f / NUMBER_OF_COLUMNS).ceil
BLANK_SPACE = 3

# ファイル/ディレクトリ名の中で一番文字数が多いものの文字数を取得する
def max_character_count
  character_count = 0
  (0...NUMBER_OF_FILES).each do |index|
    character_count = Dir[METACHARACTER][index].length\
    if character_count < Dir[METACHARACTER][index].length
  end
  character_count
end

def filename(column, row)
  Dir[METACHARACTER][column * NUMBER_OF_ROWS + row]
end

def add_space(column, row)
  ' ' * (max_character_count + BLANK_SPACE - filename(column, row).length)
end

def main
  (0...NUMBER_OF_ROWS).each do |row|
    (0...NUMBER_OF_COLUMNS).each do |column|
      print filename(column, row)
      print add_space(column, row) if filename(column, row)
    end
    print "\n"
  end
end

main
