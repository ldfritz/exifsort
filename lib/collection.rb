require "fileutils"
require "find"

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require "photo"

module Collection
  VERSION = "0.1.0"

  def self.execute!(options)
    setup options
    collect_files
    transfer_files
  end

  private
  def self.setup(options)
    @command = options[:copy] ? :cp : :mv
    @dest    = options[:dest]
    @dryrun  = options[:"dry-run"]
    @recurse = options[:recursive]
    @src     = options[:src].uniq
    @verbose = options[:verbose] || @dryrun
  end

  def self.collect_files
    @files = []
    @src.each do |dir|
      Find.find(dir) do |file|
        if File.directory?(file)
          unless file == dir
            Find.prune unless @recurse
          end
        elsif File.file?(file)
          @files << file if file.match(/jpe?g/i)
        end
      end
    end

    @files = @files.uniq.sort.collect do |file|
      Photo.new file
    end
  end

  def self.transfer_files
    output = ""
    @files.each do |file|
      dest = "#{@dest}/#{file.dest}"
      if File.exist?(dest)
        output << "skipping #{file.src}"
        if File.absolute_path(file.src) == File.absolute_path(dest)
          output << ": NO CHANGE"
        else
          output << ": #{dest} ALREADY EXISTS"
        end
        output << "\n"
      else
        unless @dryrun
          FileUtils.mkdir_p(file.dest_dir)
          FileUtils.send(@command, file.src, dest)
        end
        if @verbose
          output << "#{dest} <= #{file.src}\n"
        end
      end
    end
    output.gsub(/\/\//, "\/")
  end
end
