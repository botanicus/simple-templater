# encoding: utf-8

SPEC_ROOT = File.dirname(__FILE__)
$:.unshift(File.expand_path(File.join(SPEC_ROOT, "..", "lib")))
require "spec" # so you can run ruby spec/rango/whatever_spec.rb

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
