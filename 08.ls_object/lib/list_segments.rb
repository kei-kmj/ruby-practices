# frozen_string_literal: true

class ListSegments
  def initialize(option)
    @option = option
    @information = if @option.line?
                     LongStyle.new option
                   else
                     ShortStyle.new option
                   end
  end

  def draw
    @information.draw
  end
end
