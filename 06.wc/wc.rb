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
    calc_file(targets, option, width)
  end
end

def interactive_mode(option)
  content = output_content($stdin.read)
  print format_interactive(content[:lines])
  unless option['l']
    print format_interactive(content[:words])
    print format_interactive(content[:bytes])
  end
  print "\n"
end

def format_interactive(object)
  object.to_s.rjust(WIDTH)
end

def output_content(targets)
  { lines: targets.count("\n"),
    words: targets.split(/\s+/).size,
    bytes: targets.size }
end

def calc_file(targets, option, width)
  total_lines = 0
  total_words = 0
  total_bytes = 0
  targets.each_with_index do |file_name, index|
    content = output_content(File.read(file_name))
    print format_files(content[:lines], width)
    print format_files(content[:words], width) unless option['l']
    print format_files(content[:bytes], width) unless option['l']
    puts " #{file_name}"

    total_lines += content[:lines]
    total_words += content[:words]
    total_bytes += content[:bytes]
    # ファイルが複数あるとき、ループの最後で合計を出力する
    next if index < targets.size - 1 || targets.size == 1

    print format_files(total_lines, width)
    print format_files(total_words, width) unless option['l']
    print format_files(total_bytes, width) unless option['l']
    puts ' total'
  end
end

# byte計から文字数を計算して出力内容の間隔を指定する
def calc_width(targets)
  targets.map { |target| File.read(target).size }.sum.to_s.size + MARGIN
end

def format_files(object, width)
  object.to_s.rjust(width)
end

main
