# encoding: utf-8

require "cli"
require_relative "generator"

module SimpleTemplater
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

    protected
    def check_paths(paths)
      paths.each do |path|
        Dir.exist?(path) || raise(Errno::ENOENT, path)
      end
      return paths
    end
  end
end
