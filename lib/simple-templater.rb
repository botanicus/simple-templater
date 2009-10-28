#!/usr/bin/env ruby1.9 -Ivendor/rubyexts/lib:vendor/erubis/lib:vendor/abstract/lib:vendor/cli/lib
# encoding: utf-8

require "rubyexts"

module SimpleTemplater
  VERSION ||= "0.0.1"
  mattr_accessor :logger

  GeneratorNotFound ||= Class.new(StandardError)
end

acquire_relative "simple-templater/*.rb"

# run console if executed directly
if $0 == __FILE__
  require "irb"
  require "irb/completion"
  include SimpleTemplater
  IRB.start(__FILE__)
end
