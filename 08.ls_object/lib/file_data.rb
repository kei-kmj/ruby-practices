# frozen_string_literal: true

class FileData
  attr_reader :path, :stat, :nlink, :uid, :gid, :size, :type, :mode, :mtime

  def initialize(filepath)
    @path = filepath
    @stat = File.stat(filepath)
    @nlink = File.stat(filepath).nlink.to_s
    @uid = Etc.getpwuid(File.stat(filepath).uid).name.to_s
    @gid = Etc.getgrgid(File.stat(filepath).gid).name.to_s
    @size = File.size(filepath).to_s
    @type = File.ftype(filepath).to_s
    @mode = File.stat(filepath).mode.to_s(8)
    @mtime = File.mtime(filepath).to_date
  end
end
