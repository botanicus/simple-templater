# encoding: utf-8

require "cli"
require "simple-templater"
require "simple-templater/generator"

class SimpleTemplater
  # one project can has a generator in system gems and in ~/.rango/stubs/project,
  # and these two generators are one generator set
  class GeneratorSet
    attr_reader :name, :paths
    def initialize(name, *paths)
      @name  = name.to_sym
      @paths = self.custom + check_paths(paths)
    end

    def custom_path
      File.join(ENV["HOME"], ".#{name}", "stubs")
    end

    def custom
      directories = Dir["#{self.custom_path}/*"]
      directories.select { |file| Dir.exist?(file) }
    end

    def generators
      @generators ||= self.paths.map { |path| Generator.new(self.name, path) }
    end

    def run(args = ARGV)
      SimpleTemplater.logger.info "Looking for custom generators in #{self.custom_path}: #{self.custom.inspect}"
      full = self.generators.find { |generator| generator.full? }
      diff = self.generators.find { |generator| generator.diff? }
      raise GeneratorNotFound, "Generator set #{self.inspect} hasn't any full generator" if full.nil?
      if Dir.exist?(full.name)
        raise TargetAlreadyExist, "#{full.name} already exist, aborting."
      end
      full.run(args)
      diff.run(args) unless diff.nil?
    end

    protected
    def check_paths(paths)
      paths.each do |path|
        Dir.exist?(path) || raise(GeneratorNotFound, path)
      end
      return paths
    end
  end
end
