require "exifr"
require "date"

class Photo
  VERSION = "0.1.0"

  attr_reader :src
  alias :to_s :src

  def initialize(path)
    raise unless File.exist?(path)
    @src  = path
  end

  def dest_dir
    date.strftime("%Y/%Y-%m-%d/")
  end

  def dest
    "#{dest_dir}#{File.basename(src)}"
  end

  private
  def date
    exif = EXIFR::JPEG.new(src).exif
    begin
      exif.date_time_original || exif.date_time || Date.new(0, 1, 1)
    rescue
      Date.new(0, 1, 1)
    end
  end
end
