# frozen_string_literal: true

class Option
  def initialize
    option = ARGV.getopts('a', 'l', 'r')
    @all = option['a']
    @line = option['l']
    @reverse = option['r']
  end

  def all?
    @all
  end

  def line?
    @line
  end

  def reverse?
    @reverse
  end
end
