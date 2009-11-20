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
      @paths = check_paths(paths)
      if File.directory?(self.custom)
        SimpleTemplater.logger.info "Added custom generator from #{self.custom}"
        @paths.unshift(self.custom)
      end
    end

    def custom
      File.join(ENV["HOME"], ".simple-templater", self.name)
    end

    def generators
      @generators ||= self.paths.map { |path| Generator.new(self.name, path) }
    end

    def run(args = ARGV)
      full = self.generators.find { |generator| generator.full? }
      diff = self.generators.find { |generator| not generator.full? }
      raise GeneratorNotFound, "Generator set #{self.inspect} hasn't any full generator" if full.nil?
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
