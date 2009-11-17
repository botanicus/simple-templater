# encoding: utf-8

module SimpleTemplater
  class Main
    attr_reader :scope, :logger, :generators
    def initialize(scope, logger = nil)
      @scope      = scope
      @logger     = logger
      @generators = Hash.new
    end
    
    def logger
      @logger ||= standard_logger
    end

    def discover!
      SimpleTemplater.discover!(self.scope)
    end
    
    def generators
      SimpleTemplater.scopes[self.scope] || Hash.new
    end

    # templater.register(:project, path)
    def register(name, path)
      SimpleTemplater.register(scope, Generator.new(name, path))
    end
    
    private
    def standard_logger
      require "logger"
      Logger.new(STDOUT)
    end
  end
end
