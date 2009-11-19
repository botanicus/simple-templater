# encoding: utf-8

require "yaml"
require "ostruct"
require "fileutils"

require "simple-templater"
require "simple-templater/builder"
require "simple-templater/argv_parsing"

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
    attr_reader :name, :path, :context

    # hook do |generator, context|
    #   generator.target = "#{generator.target}.ru"
    # end
    attr_accessor :target

    def initialize(name, path)
      raise GeneratorNotFound unless File.directory?(path)
      @name, @path = name.to_sym, path
      @context = Hash.new
    end

    def parse_argv(args)
      args = args.dup
      args.extend(SimpleTemplater::ArgvParsingMixin)
      @target  = args.shift || File.basename(@path)
      @context = args.parse!
      self.context.merge!(name: File.basename(@target))
    end

    # For DSL
    def hook(&block)
      block.call(self, self.context)
    end

    # @param target ... ./blog
    # @param args Array --git-repository --no-github
    def run(args)
      self.parse_argv(args)
      self.run_hook("setup.rb")
      SimpleTemplater.logger.info("[#{self.name} generator] Creating #{@target} (#{self.config.type})")
      if self.flat?
        # flat/content/flat.ru.rbt
        # flat/content/%user%.rb
        SimpleTemplater::FlatBuilder.create(Dir["#{file("content")}/*"].first, self.target, context)
        self.run_hook("postprocess.rb")
      else
        FileUtils.mkdir_p(@target)
        Dir.chdir(@target) do
          SimpleTemplater::Builder.create(file("content"), context)
          self.run_hook("postprocess.rb")
        end
      end
    end

    def run_hook(basename)
      if File.exist?(hook = file(basename))
        SimpleTemplater.logger.info("Running #{basename} hook")
        self.instance_eval(File.read(hook))
        SimpleTemplater.logger.info("Finished")
      end
    rescue Exception => exception
      abort "Exception #{exception.inspect} occured during running #{basename}\n#{exception.backtrace.join("\n")}"
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

    def flat?
      self.config.flat
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
