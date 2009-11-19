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

    def custom
      directories = Dir["#{ENV["HOME"]}/.#{name}/stubs/*"]
      directories.select { |file| Dir.exist?(file) }
    end

    def generators
      @generators ||= self.paths.map { |path| Generator.new(self.name, path) }
    end

    def run(args = ARGV)
      full = self.generators.find { |generator| generator.full? }
      diff = self.generators.find { |generator| generator.diff? }
      raise GeneratorNotFound, "Generator set #{self.inspect} hasn't any full generator" if full.nil?
      if Dir.exist?(full.name)
        raise TargetDirectoryAlreadyExist, "#{full.name} already exist, aborting."
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
