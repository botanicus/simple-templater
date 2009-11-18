# encoding: utf-8

module SimpleTemplater
  class Main
    attr_reader :scope, :generators
    def initialize(scope, logger = nil)
      @scope      = scope
      @generators = Hash.new
    end

    def logger
      @logger ||= standard_logger
    end

    def discover!
      SimpleTemplater.discover!(self.scope)
    end

    def generators
      SimpleTemplater.generators[self.scope] || Hash.new
    end

    # templater.register(:project, path)
    def register(name, path)
      SimpleTemplater.register(self.scope, name, path)
    end

    def find(name)
      self.generators.find do |generator|
        generator.name == name.to_sym
      end
    end
  end
end
