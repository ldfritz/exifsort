#!/usr/bin/env ruby
require "fileutils"
require "rubygems"
require "exifr"
require "slop"

# Option Parser
opts = Slop.parse!(:help => true) do
  banner "Usage: exifsort [OPTIONS] FILE/DIRECTORY

Sort JPG files into dated directories based on their EXIF dates.
"
  separator "Options:"
  on "c", "copy",      "Copy images instead of moving them."
  on "d", "dest=",     "Move images to DEST instead of the current directory."
  on "dry-run",        "Run without making any changes."
  on "r", "recursive", "Locate images recursively."
end

# Defaults
DRYRUN = opts[:"dry-run"]
DEST   = opts[:dest] || "."

# Validation
if ARGV.length == 1 and File.directory?(ARGV.last)
  PATH = ARGV.last
else
  puts opts
  exit
end

# Methods
def move_to(filename, dest)
  dest += "/"
  unless DRYRUN
    Dir.mkdir(dest) if not File.exists?(dest)
    FileUtils.mv(filename, dest)
  end
  puts dest + filename
end

def get_date(filename)
  picture = EXIFR::JPEG.new(filename)
  picture.exif.date_time_original || picture.exif.date_time
end

def get_pictures(pathname)
  Dir.entries(pathname).find_all do |filename|
    filename.match(/jpe?g/i)
  end
end

# Execution
get_pictures(".").each do | filename |
  if EXIFR::JPEG.new(filename).exif?
    if get_date(filename).class == Time
      move_to(filename, get_date(filename).strftime("%Y-%m-%d"))
    else
      move_to(filename, "error")
    end
  else
    move_to(filename, "no-exif")
  end
end
