# encoding: utf-8

SPEC_ROOT = File.dirname(__FILE__)
$:.unshift(File.expand_path(File.join(SPEC_ROOT, "..", "lib")))

require "spec" # so you can run ruby spec/rango/whatever_spec.rb
# require "fakefs" # TODO: makes some troubles with rubyexts

require "stringio"

def STDOUT.capture(&block)
  before = self
  $stdout = StringIO.new
  block.call
  $stdout.rewind
  output = $stdout.read
  $stdout = before
  output
end

# @example STDOUT.capture { puts "hi" }
# # => "hi"
def STDERR.capture(&block)
  before = self
  $stderr = StringIO.new
  block.call
  $stderr.rewind
  output = $stderr.read
  $stderr = before
  output
end

# @example STDIN.capture("yes") { ask("Do you hear me?") }
# # => "yes"
def STDIN.capture(default, &block)
  STDIN.reopen "/dev/null" # so we don't get the fucking prompt
  STDIN.ungetbyte(default) # so the default value can be get by STDIN.getc & similar methods
  block.call
  # TODO: how I can get back the original STDIN?
end

module Spec
  module Matchers
    def match(expected)
      Matcher.new :match, expected do |expected|
        match do |actual|
          actual.match(expected)
        end
      end
    end
  end
end
