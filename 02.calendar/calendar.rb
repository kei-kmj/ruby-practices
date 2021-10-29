#! /usr/bin/env ruby
require 'date'
require 'optparse'
params = ARGV.getopts('m:y:')

month = params['m']&.to_i || Date.today.month
year = params['y']&.to_i || Date.today.year

if month < 1 || month > 12
  puts "#{month} is neither a month number (1..12) nor a name"
  exit
end

if year < 1 || year > 9999
  puts "year '#{year}' not range 1..9999"
  exit
end

puts "   #{month}月　#{year}"
puts '日 月 火 水 木 金 土'

firstday = Date.new(year, month, 1)
print "\s" * 3 * firstday.wday

lastday = Date.new(year, month, -1)

def print_color(current_date)
  # エスケープシーケンスで色を変更
  # 色変更は1箇所だけなので、ライブラリを使うまでもないと思った
  print "\e[30;47m#{current_date.strftime('%e')}\e[0m", "\s"
end

(firstday..lastday).each do |current_date|
  if current_date == Date.today
    print_color(current_date)
  else
    print(current_date.strftime('%e'), "\s")
  end
  print "\n" if current_date.saturday?
end
print "\n"
