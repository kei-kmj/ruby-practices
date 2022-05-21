# frozen_string_literal: true

class ListSegments
  def initialize(option)
    @option = option
  end

  def draw
    @ordered_files = ordered_files
    @files_data_list = files_data_list
    switch_style
    @style.draw
  end

  private

  def ordered_files
    if @option.reverse?
      extract_files.reverse
    else
      extract_files
    end
  end

  def extract_files
    @option.all? ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end

  def files_data_list
    @ordered_files.map do |filepath|
      FileData.new(filepath)
    end
  end

  def switch_style
    @style = if @option.line?
               LongStyle.new(@files_data_list)
             else
               ShortStyle.new(@files_data_list)
             end
  end
end
