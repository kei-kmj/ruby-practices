#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8

def main
  option = ARGV.getopts('l')
  targets = ARGV
  if targets.empty?
    interactive_mode(option)
  else
    total_bytes = total_bytes(targets, option)
    width = width(total_bytes)
    calc_file(targets, option)
    print_total(targets, option) if targets.size > 1
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

def calc_file(targets, option)
  targets.each do |file_name|
    file = File.read(file_name)
    lines = file.count("\n")
    words = file.split(/\s+/).size
    bytes = file.size

    # 文字間隔をtotal_bytesの文字数に合わせる
    # 本当は行、単語数のそれぞれ文字間を計算してハッシュに入れたかった。
    # 要素数1つなら上手く行ったが、2つ以上になったら引数をうまく指定できなかった。
    total_bytes = total_bytes(targets, option)
    width = width(total_bytes)

    print lines.to_s.rjust(width)
    unless option['l'] # 1行で書いたらrubocopに叱られた
      print words.to_s.rjust(width)
      print bytes.to_s.rjust(width)
    end
    puts " #{file_name}"
  end
end

# total_bytesのみ再利用するためメソッドにした
def total_bytes(targets, _option)
  (0...targets.size).sum { |n| File.read(targets[n]).size }
end

# 再利用1:文字数を計算して文字間隔を指定する
def width(total_bytes)
  total_bytes.to_s.size + 1
end

def print_total(targets, option)
  total_lines = (0...targets.size).sum { |n| File.read(targets[n]).count("\n") }
  total_words = (0...targets.size).sum { |n| File.read(targets[n]).split(/\s+/).size }
  # 再利用2:total_bytesの出力
  total_bytes = total_bytes(targets, option)
  width = width(total_bytes)

  # 処理a':処理としては疑似的なので、1回で書けないものかと思う（自分では出来ない）
  print total_lines.to_s.rjust(width)
  unless option['l']
    print total_words.to_s.rjust(width)
    print total_bytes.to_s.rjust(width)
  end
  puts ' total'
end

main
