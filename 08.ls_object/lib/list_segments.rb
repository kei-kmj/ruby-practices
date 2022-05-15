# frozen_string_literal: true

class ListSegments
  attr_reader :file

  def initialize(option)
    @option = option

    file_order = if @option.reverse?
                   extract_files.reverse
                 else
                   extract_files
                 end

    files = file_order.map do |file|
      FileData.new(file)
    end

    @list = if @option.line?
              LongStyle.new(files)
            else
              ShortStyle.new(files)
            end
  end

  def draw
    @list.draw
  end

  private

  def extract_files
    @option.all? ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end
end
