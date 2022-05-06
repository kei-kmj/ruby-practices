# frozen_string_literal: true

class ExtractFiles
  attr_reader :files

  def initialize(option)
    @files = Dispatch.new
    @option = option
  end

  def extract
    @files = if @option.all?
               @files.all
             else
               @files.dots_excluded
             end

    @files = @files.reverse if @option.reverse?
    @files
  end
end
