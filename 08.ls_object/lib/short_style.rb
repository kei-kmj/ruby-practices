# frozen_string_literal: true

class ShortStyle
  MARGIN = 2
  NUMBER_OF_COLUMNS = 3

  def initialize(files)
    @files = files
  end

  def draw
    # files = @files
    width = calc_width
    (0...number_of_rows).each do |row|
      (0...NUMBER_OF_COLUMNS).each do |column|
        regulation = column * number_of_rows + row
        file = @files[regulation]
        show_content(file.path, width)
      end
      print "\n"
    end
  end

  private

  def number_of_rows
    (number_of_files.to_f / NUMBER_OF_COLUMNS).ceil
  end

  def number_of_files
    @files.length
  end

  def show_content(file, width)
    print file.ljust(width) if file
  end

  def calc_width
    filepath = @files.map(&:path)
    filepath.max_by(&:length).length + MARGIN
  end
end