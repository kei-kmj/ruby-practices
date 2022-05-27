# frozen_string_literal: true

class ShortStyle
  MARGIN = 2
  NUMBER_OF_COLUMNS = 3

  def initialize(files)
    @files = files
  end

  def draw
    width = calc_width
    number_of_rows = (@files.length.to_f / NUMBER_OF_COLUMNS).ceil
    number_of_rows.times do |row|
      NUMBER_OF_COLUMNS.times do |column|
        regulation = column * number_of_rows + row
        file = @files[regulation]
        print file.path.ljust(width) if file
      end
      print "\n"
    end
  end

  private

  def calc_width
    filepath = @files.map(&:path)
    filepath.max_by(&:length).length + MARGIN
  end
end
