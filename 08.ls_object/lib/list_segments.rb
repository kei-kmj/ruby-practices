# frozen_string_literal: true

class ListSegments
  def initialize(option)
    @option = option
  end

  def draw
    ordered_files =
      @option.reverse? ? extract_files.reverse : extract_files
    files_data_list(ordered_files)
    switch_style(ordered_files).draw
  end

  private

  def extract_files
    @option.all? ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end

  def files_data_list(ordered_files)
    ordered_files.map do |filepath|
      FileData.new(filepath)
    end
  end

  def switch_style(ordered_files)
    if @option.line?
      LongStyle.new(files_data_list(ordered_files))
    else
      ShortStyle.new(files_data_list(ordered_files))
    end
  end
end
