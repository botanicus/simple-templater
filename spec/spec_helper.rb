# encoding: utf-8

SPEC_ROOT = File.dirname(__FILE__)
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
