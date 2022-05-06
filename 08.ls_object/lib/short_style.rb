# frozen_string_literal: true

class ShortStyle
  NUMBER_OF_COLUMNS = 3
  WIDTH = 20

  def initialize(opt)
    @files = ExtractFiles.new opt
  end

  def draw
    files = @files.extract
    (0...number_of_rows(files)).each do |row|
      (0...NUMBER_OF_COLUMNS).each do |column|
        name = files[column * number_of_rows(files) + row]
        show_content(name)
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

  def show_content(name)
    print name.ljust(WIDTH) if name
  end
end
