# frozen_string_literal: true

class FileData
  attr_reader :path

  def initialize(filepath)
    @path = filepath
    @stat = File.stat(@path)
  end

  def blocks
    @stat.blocks
  end

  def nlink
    @stat.nlink
  end

  def user_name
    Etc.getpwuid(@stat.uid).name
  end

  def group_name
    Etc.getgrgid(@stat.gid).name
  end

  def size
    File.size(@path)
  end

  def ftype
    File.ftype(@path)
  end

  def mode
    @stat.mode
  end

  def mtime
    File.mtime(@path)
  end
end
