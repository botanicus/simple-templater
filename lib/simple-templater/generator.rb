# encoding: utf-8

require "yaml"
require "ostruct"
require "fileutils"

require_relative "../simple-templater"

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
class SimpleTemplater
  class Generator
    attr_reader :name, :path
    def initialize(name, path)
      raise GeneratorNotFound unless File.directory?(path)
      @name, @path = name.to_sym, path
    end

    # @param target ... ./blog
    # @param args Array --git-repository --no-github
    def run(target, *args)
      @target = target
      self.load_setup
      SimpleTemplater.logger.info("[#{self.name} generator] Creating #{@target} (#{self.config.type})")
      FileUtils.mkdir_p(@target)
      Dir.chdir(@target) do
        ARGV.clear.push(*[file("content"), args].flatten.compact)
        if File.exist?(hook = File.join(self.path, "preprocess.rb"))
          begin
            load hook
          rescue Exception => exception
            abort "Exception #{exception.inspect} occured during running preprocess.rb\n#{exception.backtrace.join("\n")}"
          end
        end
        SimpleTemplater::Builder.create(file("content"))
      end
      self.run_postprocess_hook
    end

    def load_setup
      if File.exist?(hook = file("preprocess.rb"))
        load(hook) && SimpleTemplater.logger.info("Running preprocess.rb hook")
      end
    end

    def run_postprocess_hook
      Dir.chdir(@target) do
        if File.exist?(hook = File.join(self.path, "postprocess.rb"))
          load(hook) && SimpleTemplater.logger.info("Running postprocess.rb hook")
        end
      end
    rescue Exception => exception
      abort "Exception #{exception.inspect} occured during running postprocess.rb\n#{exception.backtrace.join("\n")}"
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
