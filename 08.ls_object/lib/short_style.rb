# frozen_string_literal: true

MARGIN = 2
class ShortStyle
  NUMBER_OF_COLUMNS = 3
  WIDTH = 20

  def initialize(files)
    @files = files
  end

  def draw
    files = @files
    width = width(files)
    (0...number_of_rows(files)).each do |row|
      (0...NUMBER_OF_COLUMNS).each do |column|
        file = files[column * number_of_rows(files) + row]
        show_content(file, width)
      end
      print "\n"
    end
  end

  private

  def number_of_rows(files)
    (number_of_files(files).to_f / NUMBER_OF_COLUMNS).ceil
  end

  def number_of_files(files)
    files.length
  end

  def show_content(file, width)
    print file.ljust(width) if file
  end

  def width(files)
    files.max_by(&:length).length + MARGIN
  end


end
