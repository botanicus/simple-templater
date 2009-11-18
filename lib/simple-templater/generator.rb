# encoding: utf-8

require "yaml"
require "ostruct"
require "fileutils"

require_relative "../simple-templater"
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
    attr_reader :name, :path
    def initialize(name, path)
      raise GeneratorNotFound unless File.directory?(path)
      @name, @path = name.to_sym, path
    end

    # @param location ... ./blog
    # @param args Array --git-repository --no-github
    def run(location, *args)
      self.load_setup
      SimpleTemplater.logger.info("Creating #{self.config.type} #{self.name} from stubs in #{location}")
      FileUtils.mkdir_p(self.name)
      Dir.chdir(self.name) do
        ARGV.clear.push(*[self.content_dir(location), @args].flatten.compact)
        if File.exist?(hook = File.join(self.path, "preprocess.rb"))
          load hook
        else
          SimpleTemplater::Templater.create(self.content_dir)
        end
      end
      self.run_postprocess_hook
    end

    def load_setup
      if File.exist?(hook = file("preprocess.rb"))
        load(hook) && SimpleTemplater.logger.inspect("Running preprocess.rb hook")
      end
    end

    def run_postprocess_hook
      Dir.chdir(@name) do
        if File.exist?(hook = File.join(self.path, "postprocess.rb"))
          load(hook) && SimpleTemplater.logger.inspect("Running postprocess.rb hook")
        end
      end
    end

    def file(path)
      File.join(self.path, path)
    end

    def full?
      self.config.type.eql?("full")
    end

    def diff?
      self.config.type.eql?("diff")
    end

    # Metadata options
    # :type: full|diff
    # :file: flat.ru
    def metadata
      metadata_file = File.join(self.path, "metadata.yml")
      YAML::load_file(metadata_file)
    rescue Errno::ENOENT
      SimpleTemplater.logger.fatal("SimpleTemplater expected '#{metadata_file}'")
    end

    def config
      defaults = {processing: true, type: "full", directory: true}
      OpenStruct.new(defaults.merge(self.metadata))
    end
  end
end
