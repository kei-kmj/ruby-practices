#!/usr/bin/env ruby
score = ARGV[0]
scores = score.split(',')
shots = []

h = shots.size
scores.each do |score|
  # 最終フレームかそうでないかで処理を変える
  # 8投目にxがくることはありえない
  if  h < 8
    if score == "x"
      shots << 10
      shots << 0
    else
      shots << score.to_i
    end
    h = shots.size
  else
    if score == "x"
      shots << 10
    else
      shots << score.to_i
    end
  end
end
frames = []
game = shots.shift 8
game.each_slice(2) do |s|
  frames << s
end
frames[4] = shots
p frames
gain = 0
frames.each_with_index do |frames, i|
  
  p frames , i
  if frames[i] == [10, 0]
    if frames[i + 1] == [10, 0]
      gain += 20 + frames[i + 2][0]
    else
      gain += 10 + frames[i + 1].sum
    end
  elsif frames[i].sum == 10
    gain += 10 + frames[i + 1][0]
  else
    gain += frames[i].sum
  end
  throw :exit if i == 2
end

# 4フレーム目
if frames[3] == [10, 0]
  gain = frames[4][0] + frames[4][1] 
elsif frames[3].sum == 10
  gain += 10 + frames[4][0]
else
  gain += frames[3].sum
end

# 最終フレーム
gain += frames[4].sum
p gain












