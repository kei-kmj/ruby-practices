# frozen_string_literal: true

class FileData
  attr_reader :path, :stat

  def initialize(filepath)
    @path = filepath
    @stat = File.stat(@path)
  end

  def nlink
    @stat.nlink
  end

  def uid
    Etc.getpwuid(@stat.uid)
  end

  def gid
    Etc.getgrgid(@stat.gid)
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
