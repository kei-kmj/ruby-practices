# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'
require_relative 'lib/option'
require_relative 'lib/short_style'
require_relative 'lib/long_style'
require_relative 'lib/file_data'
require_relative 'lib/list_segments'

option = Option.new
ls = ListSegments.new option
ls.draw
