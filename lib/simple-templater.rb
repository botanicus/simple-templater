#!/usr/bin/env ruby -Ivendor/erubis/lib:vendor/abstract/lib:vendor/cli/lib
# encoding: utf-8

class Hash
  def reverse_merge!(hash)
    self.replace(hash.merge(self))
  end
end

require "simple-templater/core_exts"
require "simple-templater/discoverer"
require "simple-templater/generator_set"

class SimpleTemplater
  VERSION ||= "0.0.1.4"

  GeneratorNotFound ||= Class.new(StandardError)
  TargetAlreadyExist ||= Class.new(StandardError)

  def self.logger
    @@logger ||= begin
      require "logger"
      Logger.new(STDOUT)
    end
  end

  def self.logger=(logger)
    @@logger = logger
  end

  def self.scopes
    @scopes ||= Hash.new
  end

  # scope => generator
  # rango: GeneratorSet.new(:project, *paths)
  def self.generators
    @generators ||= Hash.new
  end

  # Adds a block of code specific for a certain scope of generators, where the scope would
  # probably be the name of the program running the generator.
  #
  # === Parameters
  # scope<String>:: The name of the scope
  # block<&Proc>:: A block of code to execute provided the scope is correct
  def self.scope(scope, &block)
    self.scopes[scope] ||= Array.new
    self.scopes[scope] << block
  end

  def self.register(scope, name, *paths)
    self.generators[scope] ||= Array.new
    self.generators[scope].push(GeneratorSet.new(name, *paths))
  end

  # Searches installed gems for simple-templater.scope files and loads all code blocks in them that match
  # the given scope.
  #
  # === Parameters
  # scope<String>:: The name of the scope to search for
  def self.discover!(scope)
    klass = Discoverer.detect
    discoverer = klass.new(scope)
    discoverer.run
  end

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

# run console if executed directly
if $0 == __FILE__
  require "irb"
  require "irb/completion"
  include SimpleTemplater
  IRB.start(__FILE__)
end
