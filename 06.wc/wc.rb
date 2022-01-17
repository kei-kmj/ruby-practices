﻿#!/usr/bin/env ruby
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
    # 文字間隔をtotal_bytesの文字数に合わせる
    # 本当は行、単語数、バイト数それぞれの文字間を計算してハッシュに入れたかった。
    # 要素数1つなら上手く行ったが、2つ以上になったら引数をうまく指定できなかった。
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
  unless option['l'] # 1行で書いたらrubocopに叱られた
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
  (0...targets.size).sum { |n| File.read(targets[n]).size }
end

def calc_file(targets, option, total_bytes)
  targets.each do |file_name|
    file = File.read(file_name)
    lines = file.count("\n")
    words = file.split(/\s+/).size
    bytes = file.size

    print format_files(lines, total_bytes)
    unless option['l'] # 1行で書いたらrubocopに叱られた
      print format_files(words, total_bytes)
      print format_files(bytes, total_bytes)
    end
    puts " #{file_name}"
  end
end

# 利用1:文字数を計算して文字間隔を指定する
def width(total_bytes)
  total_bytes.to_s.size + MARGIN
end

def print_total(targets, option, total_bytes)
  total_lines = (0...targets.size).sum { |n| File.read(targets[n]).count("\n") }
  total_words = (0...targets.size).sum { |n| File.read(targets[n]).split(/\s+/).size }
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
