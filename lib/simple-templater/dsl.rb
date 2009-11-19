# encoding: utf-8

require "fileutils"
require "cli" # yes? etc

class SimpleTemplater
  class DSL
    include FileUtils
    attr_reader :generator, :context
    def initialize(generator)
      @generator = generator
      @context   = generator.context
    end

    def make_executable(path)
      sh "chmod +x '#{path}'"
    end
    
    def file(name, &block)
      File.open(name, "w", &block)
    end
    
    def hook(&block)
      block.call(self.generator, self.context)
    end
  end
end
