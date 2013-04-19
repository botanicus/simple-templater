#!/usr/bin/env nake
# encoding: utf-8

$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))

require "nake/tasks/gem"
require "nake/tasks/spec"
require "nake/tasks/release"

begin
  load "code-cleaner.nake"
  Nake::Task["hooks:whitespace:install"].tap do |task|
    task.config[:path] = "script"
    task.config[:encoding] = "utf-8"
    task.config[:whitelist] = '(bin/[^/]+|.+\.(rb|rake|nake|thor|task))$'
  end
rescue LoadError
  warn "If you want to contribute to SimpleTemplater, please install code-cleaner and then run ./tasks.rb hooks:whitespace:install to get Git pre-commit hook for removing trailing whitespace."
end

require_relative "lib/simple-templater"

# Setup encoding, so all the operations
# with strings from another files will work
Encoding.default_internal = "utf-8"
Encoding.default_external = "utf-8"

Task[:build].config[:gemspec] = "simple-templater.gemspec"
Task[:prerelease].config[:gemspec] = "simple-templater.pre.gemspec"
Task[:release].config[:name] = "simple-templater"
Task[:release].config[:version] = SimpleTemplater::VERSION
