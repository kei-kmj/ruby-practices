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
    total_bytes = total_bytes(targets, option)

    calc_file(targets, option, total_bytes)
    print_total(targets, option, total_bytes) if targets.size > 1
  end
end

def interactive_mode(option)
  targets = $stdin.read
  lines = targets.lines.count
  words = targets.split(/\s+/).size
  bytes = targets.size

  print format_interactive(lines)
  unless option['l']
    print format_interactive(words)
    print format_interactive(bytes)
  end
  print "\n"
end

def format_interactive(object)
  object.to_s.rjust(WIDTH)
end

# total_bytesのみ再利用するためメソッドにした
def total_bytes(targets, _option)
  #(0...targets.size).sum { |n| File.read(targets[n]).size }
  targets.map { |target| File.read(target).size }.sum
end

def calc_file(targets, option, width)
  targets.each do |file_name|
    file = File.read(file_name)
    lines = file.count("\n")
    words = file.split(/\s+/).size
    bytes = file.size

    print format_files(lines, width)
    unless option['l']
      print format_files(words, width)
      print format_files(bytes, width)
    end
    puts " #{file_name}"
  end
end

# 利用1:文字数を計算して出力内容の間隔を指定する
def width(total_bytes)
  total_bytes.to_s.size + MARGIN
end

def print_total(targets, option, total_bytes)

  total_lines = targets.map { |target| File.read(target).count("\n") }.sum
  total_words = targets.map { |target| File.read(target).split(/\s+/).size }.sum
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
