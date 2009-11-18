# encoding: utf-8

require "cli"

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

    protected
    def check_paths(paths)
      paths.map do |path|
        Dir.exist?(path) || raise(Errno::ENOENT, path)
      end
    end
  end
end
