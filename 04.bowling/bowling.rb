#!/usr/bin/env ruby
score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |score|
  if score == "x"
    shots << 10
    shots << 0
  else
    shots << score.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

def double_strike(frames, i)
  frames[i] == [10, 0] && frames[i + 1] == [10, 0]
end

def single_strike(frames, i)
  frames[i] == [10, 0]
end

def spare(frames, i)
  frames[i].sum == 10
end

total = 0
frames.each_index do |i|
  #9フレーム目までの処理
  if i < 9
    if double_strike(frames, i)
      total += 20 + frames[i + 2][0]
    elsif single_strike(frames, i) 
      total += 10 + frames[i + 1].sum
    elsif spare(frames, i)
      total += 10 + frames[i + 1][0]
    else
      total += frames[i].sum
    end
  else
    total += frames[i].sum
  end
end
p total