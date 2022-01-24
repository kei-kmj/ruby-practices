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
    total_bytes = total_bytes(targets, option)

    calc_file(targets, option, total_bytes)
    print_total(targets, option, total_bytes) if targets.size > 1
  end
end

def interactive_mode(option)
  targets = $stdin.read
  print format_interactive(output(targets)[:lines])
  unless option['l']
    print format_interactive(output(targets)[:words])
    print format_interactive(output(targets)[:bytes])
  end
  print "\n"
end

def format_interactive(object)
  object.to_s.rjust(WIDTH)
end

def output(targets)
  { lines: targets.count("\n"),
    words: targets.split(/\s+/).size,
    bytes: targets.size }
end

# total_bytesのみ再利用するためメソッドにした
def total_bytes(targets, _option)
  targets.map { |target| File.read(target).size }.sum
end

def calc_file(targets, option, width)
  targets.each do |file_name|
    targets = File.read(file_name)
    print format_files(output(targets)[:lines], width)
    unless option['l']
      print format_files(output(targets)[:words], width)
      print format_files(output(targets)[:bytes], width)
    end
    puts " #{file_name}"

  end
end

# 利用1:文字数を計算して出力内容の間隔を指定する
def width(total_bytes)
  total_bytes.to_s.size + MARGIN
end

def print_total(targets, option, total_bytes)
  total_lines = 0
  total_words = 0
  targets.each do |filename|
    targets = File.read(filename)
    total_lines += output(targets)[:lines]
    total_words += output(targets)[:words]
  end
  # 利用2:total_bytes自体の出力
  print format_files(total_lines, total_bytes)
  unless option['l']
    print format_files(total_words, total_bytes)
    print format_files(total_bytes, total_bytes)
  end
  puts ' total'
end

def format_files(object, total_bytes)
  width = width(total_bytes)
  object.to_s.rjust(width)
end

main
