#!/usr/bin/env ruby

require 'fileutils'

require 'rubygems'
require 'exifr'

DRYRUN = ARGV[ 0 ] == '-t' ? true : false

def move_to( filename, dest )
  dest += '/'
  unless DRYRUN
    Dir.mkdir( dest ) if not File.exists?( dest )
    FileUtils.mv( filename, dest )
  end
  puts dest + filename
end

def get_date( filename )
  picture = EXIFR::JPEG.new( filename )
  picture.exif.date_time_original || picture.exif.date_time
end

def get_pictures( pathname )
  Dir.entries( pathname ).find_all do |filename|
    filename.match( /jpe?g/i )
  end
end

get_pictures( '.' ).each do | filename |
  if EXIFR::JPEG.new( filename ).exif?
    if get_date( filename ).class == Time
      move_to( filename, get_date( filename ).strftime( "%Y-%m-%d" ) )
    else
      move_to( filename, 'error' )
    end
  else
    move_to( filename, 'no-exif' )
  end
end
