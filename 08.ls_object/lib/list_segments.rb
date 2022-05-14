# frozen_string_literal: true

class ListSegments
  def initialize(option)
    @option = option
    files = if @option.reverse?
              extract_files.reverse
            else
              extract_files
            end

    @information = if @option.line?
                     LongStyle.new(files)
                   else
                     ShortStyle.new(files)
                   end
  end

  def draw
    @information.draw
  end

  private

  def extract_files
    @option.all? ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end
end
