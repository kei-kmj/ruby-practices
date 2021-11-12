# frozen_string_literal: true

require 'fileutils'

METACHARACTER = '*'
NUMBER_OF_FILES = Dir[METACHARACTER].size
NUMBER_OF_COLUMNS = 3
NUMBER_OF_ROWS = (NUMBER_OF_FILES.to_f / NUMBER_OF_COLUMNS).ceil

# ファイル/ディレクトリ名の中で一番文字数が多いものの文字数を取得する
def calc_character_count
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
  ' ' * (calc_character_count + 3 - filename(column, row).length)
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