# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |shot|
  if shot == 'x'
    shots << 10
    shots << 0
  else
    shots << shot.to_i
  end
end

frames = []
frames = shots.each_slice(2).to_a

def double_strike?(frames, index)
  frames[index] == [10, 0] && frames[index + 1] == [10, 0]
end

def single_strike?(frames, index)
  !double_strike?(frames, index) && frames[index] == [10, 0]
end

def spare?(frames, index)
  !single_strike?(frames, index) && frames[index].sum == 10
end

total = 0
frames.each_index do |index|
  total +=
    # 9フレーム目までの処理
    if index < 9
      if double_strike?(frames, index)
        20 + frames[index + 2][0]
      elsif single_strike?(frames, index)
        10 + frames[index + 1].sum
      elsif spare?(frames,index)
        10 + frames[index + 1][0]
      else
        frames[index].sum
      end
    # 10フレーム目の処理
    else
      frames[index].sum
    end
end
p total
