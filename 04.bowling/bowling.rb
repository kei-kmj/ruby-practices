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

frames = shots.each_slice(2).to_a

def strike?(frame)
  frame == [10, 0]
end

def double_strike?(frame, next_frame)
  strike?(frame) && strike?(next_frame)
end

def single_strike?(frame, next_frame)
  !double_strike?(frame, next_frame) && strike?(frame)
end

def spare?(frame, next_frame)
  !single_strike?(frame, next_frame) && frame.sum == 10
end

total = 0

(frames + [nil]).each_cons(3).each_with_index do |(frame, next_frame, after_next_frame), index|
  total +=
    if double_strike?(frame, next_frame)
      20 + after_next_frame[0]
    elsif single_strike?(frame, next_frame)
      10 + next_frame.sum
    elsif spare?(frame, next_frame)
      10 + next_frame[0]
    else
      frame.sum
    end
  break if index == 8
end

last_frame = []
last_frame << frames[9]
last_frame << frames[10] if frames[10]
last_frame << frames[11] if frames[11]

p total + last_frame.flatten.sum
