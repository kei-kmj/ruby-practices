#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8
MARGIN = 1

def main
  option = ARGV.getopts('l')
  targets = ARGV
  if targets.empty?
    interactive_mode(option)
  else
    # 出力物間のスペース数を、バイト数の合計値の桁数で調整する
    width = calc_width(targets)
    read_file_mode(targets, option, width)
  end
end

def interactive_mode(option)
  lines, words, bytes = count_in($stdin.read)
  print_content(option, bytes, lines, words, WIDTH)
  print "\n"
end

def count_in(content)
  [
    content.count("\n"),
    content.split(/\s+/).size,
    content.size
  ]
end

def print_content(option, bytes, lines, words, width)
  print format_content(lines, width)
  return if option['l']

  print format_content(words, width)
  print format_content(bytes, width)
end

def read_file_mode(targets, option, width)
  total_lines = 0
  total_words = 0
  total_bytes = 0
  targets.each do |file_name|
    lines, words, bytes = count_in(File.read(file_name))
    print_content(option, bytes, lines, words, width)
    puts " #{file_name}"

    total_lines += lines
    total_words += words
    total_bytes += bytes
  end
  return if targets.size == 1

  print_content(option, total_bytes, total_lines, total_words, width)
  puts ' total'
end

# byte計から文字数を計算して出力内容の間隔を指定する
def calc_width(targets)
  targets.map { |target| File.read(target).size }.sum.to_s.size + MARGIN
end

def format_content(object, width)
  object.to_s.rjust(width)
end

main
