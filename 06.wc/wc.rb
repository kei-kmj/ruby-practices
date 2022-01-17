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
    # 文字間隔をtotal_bytesの文字数に合わせる
    # 本当は行、単語数のそれぞれ文字間を計算してハッシュに入れたかった。
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

  print format(lines)
  unless option['l'] # 1行で書いたらrubocopに叱られた
    print format(words)
    print format(bytes)
  end
  print "\n"
end

def format(obj)
  obj.to_s.rjust(WIDTH)
end

def calc_file(targets, option, total_bytes)
  targets.each do |file_name|
    file = File.read(file_name)
    lines = file.count("\n")
    words = file.split(/\s+/).size
    bytes = file.size

    width = width(total_bytes)

    print lines.to_s.rjust(width)
    unless option['l'] # 1行で書いたらrubocopに叱られた
      print words.to_s.rjust(width)
      print bytes.to_s.rjust(width)
    end
    puts " #{file_name}"
  end
end

def total_format(obj)
  obj.to_s.rjust(width(total_bytes(targets, _option)))
end

# total_bytesのみ再利用するためメソッドにした
def total_bytes(targets, _option)
  (0...targets.size).sum { |n| File.read(targets[n]).size }
end

# 利用1:文字数を計算して文字間隔を指定する
def width(total_bytes)
  total_bytes.to_s.size + MARGIN
end

def print_total(targets, option, total_bytes)
  total_lines = (0...targets.size).sum { |n| File.read(targets[n]).count("\n") }
  total_words = (0...targets.size).sum { |n| File.read(targets[n]).split(/\s+/).size }
  # 利用2:total_bytes自体の出力
  # total_bytes = total_bytes(targets, option)
  width = width(total_bytes)

  print total_lines.to_s.rjust(width)
  unless option['l']
    print total_words.to_s.rjust(width)
    print total_bytes.to_s.rjust(width)
  end
  puts ' total'
end

main
