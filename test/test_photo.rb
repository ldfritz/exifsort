base_path = "#{File.expand_path(File.dirname(__FILE__))}/../"

require "rubygems"
    gem "minitest"
require "minitest/autorun"

$LOAD_PATH.unshift("#{base_path}/lib")
require "photo"

describe Photo do
  before do
    @photo = Photo.new("#{base_path}/sample/DSCF5948.jpg")
  end

  describe "#new" do
    it "requires a valid filename" do
      proc { Photo.new("non-existant-image.jpg") }.must_raise RuntimeError
    end
  end

  describe "#dest" do
    it "generates the complete relative path to the new destination" do
      @photo.dest.must_equal "2014/2014-02-25/DSCF5948.jpg"
    end
  end

  describe "#dest_dir" do
    it "generates the relative path of the directory of the new destination" do
      @photo.dest_dir.must_equal "2014/2014-02-25/"
    end
  end
end
