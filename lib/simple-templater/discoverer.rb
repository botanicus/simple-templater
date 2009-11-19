# encoding: utf-8

class SimpleTemplater
  class Discoverer
    def self.detect
      # TODO: coming in version 0.2
      require "simple-templater/discoverers/gems"
      SimpleTemplater::RubyGems
    end

    attr_reader :scope
    def initialize(scope)
      @scope = scope
    end

    def run
      raise NotImplementedError
    end
  end
end
