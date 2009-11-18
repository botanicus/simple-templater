# encoding: utf-8

require "yaml"
require "ostruct"
require "fileutils"

require_relative "main"

# yes? etc
require "cli"

# - Find possible location and take first one
# - If type of the location is full, then copy it's content directory to the desired name
# - If type of the location is diff, then take another location, copy it and then copy files from the first one
# - Run init.rb

# === Hooks ===

# == preprocessing.rb ==
# @foo = "bar"
# <%= %> a <%% %%>

# models/%model%.rb
# model.rb.rbt, posts.html.erb.rbt

# content/foo
# xxx/bar
# => simple-templater project blog --models=post,tag --controllers=posts,tags
module SimpleTemplater
  class Generator
    # TODO
    def self.stubs_dirs
      ["#{os.home}/.rango/stubs", "#{self.rango_root}/stubs"]
    end

    def self.list
      output = Hash.new
      self.stubs_dirs.each do |directory|
        files = map { |directory| Dir["#{directory}/*"] }.flatten
        directories = files.select { |file| Dir.exist?(file) }
        output[directory] = directories
      end
      return output
    end

    def initialize(name, path, *args)
      raise GeneratorNotFound unless File.directory?(path)
      @name, @args = name, args
      if File.exist?(name)
        abort "#{name} already exist, aborting."
      end
    end

    def stubs_dirs
      dirs = self.class.stubs_dirs.dup
      dirs.map! { |dir| "#{dir}/#{self.config.type}" }
      dirs.find { |dir| Dir.exist?(dir) }
    end

    def content_dir
      "#{@stubs_dir}/content"
    end

    def create
      self.stubs_dirs.each do |stubs_dir|
        @stubs_dir = stubs_dir
        self.proceed
      end
    end

    def proceed
      SimpleTemplater.logger.info("Creating #{self.config.type} #{@name} from stubs in #{@stubs_dir}")
      FileUtils.mkdir_p(@name)
      Dir.chdir(@name) do
        ARGV.clear.push(*[self.content_dir, @args].flatten.compact)
        if File.exist?(hook = File.join(@stubs_dir, "preprocess.rb"))
          load hook
        else
          Rango::CLI::Templater.create(self.content_dir)
        end
      end
      self.run_init_hook
    end

    def run_init_hook
      Dir.chdir(@name) do
        if File.exist?(hook = File.join(@stubs_dir, "postprocess.rb"))
          load(hook) && SimpleTemplater.logger.inspect("Running postprocess.rb hook")
        end
      end
    end

    def validations
      ["diff", "full"].include?(self.config.type)
    end

    # Metadata options
    # :type: full|diff
    # :file: flat.ru
    def metadata
      metadata_file = File.join(@stubs_dir, "metadata.yml")
      YAML::load_file(metadata_file)
    rescue Errno::ENOENT
      SimpleTemplater.logger.fatal("Rango expected '#{metadata_file}'")
    end

    def config
      defaults = {processing: true, type: "full", directory: true}
      OpenStruct.new(defaults.merge(self.metadata))
    end
  end
end
