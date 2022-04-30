# frozen_string_literal: true

class Shots
  def initialize(marks)
    @marks = marks.split(',')
    @shots = []
    @marks.each do |m|
      if m == 'X'
        @shots << 10 << 0
      else
        @shots << m.to_i
      end
    end
  end

  def frames
    @shots.each_slice(2).to_a
  end
end

class Game
  def initialize(marks)
    @shots = Shots.new(marks)
  end

  def scores
    frames = @shots.frames
    frames.values_at(0..11).each_cons(3).sum do |frame, next_frame, after_next_frame|
      calc_score(frame, next_frame, after_next_frame)
    end
  end

  private

  def calc_score(frame, next_frame, after_next_frame)
    if double_strike?(frame, next_frame)
      20 + after_next_frame[0]
    elsif single_strike?(frame, next_frame)
      10 + next_frame.sum
    elsif spare?(frame, next_frame)
      10 + next_frame[0]
    else
      frame.sum
    end
  end

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
end

p Game.new(ARGV.first).scores
