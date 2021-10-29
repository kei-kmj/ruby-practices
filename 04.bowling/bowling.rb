#!/usr/bin/env ruby
score = ARGV[0]
scores = score.split(',')
shots = []
shot = 1
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

total = 0
frames.each_with_index do |f, i|
  if i < 9
    if frames[i] == [10, 0] && frames[i + 1] == [10, 0]
      total += 20 + frames[i + 2][0]
    elsif frames[i] == [10, 0]
      total += 10 + frames[i + 1].sum
    elsif frames[i].sum == 10
      total += 10 + frames[i + 1][0]
    else
      total += frames[i].sum
    end
  else
    total += frames[i].sum
  end
end
p total