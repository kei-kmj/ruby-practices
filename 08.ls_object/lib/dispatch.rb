# frozen_string_literal: true

class Dispatch
  attr_reader :files

  def initialize
    @files = files
  end

  def all
    @files = Dir.glob('*', File::FNM_DOTMATCH)
  end

  def dots_excluded
    @files = Dir.glob('*')
  end

  def reverse
    @files.reverse
  end
end
