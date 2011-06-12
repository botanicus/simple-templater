#!/usr/bin/env gem build
# encoding: utf-8

# NOTE: we can't use require_relative because when we run gem build, it use eval for executing this file
require File.join(File.dirname(__FILE__), "lib", "simple-templater")
require "base64"

Gem::Specification.new do |s|
  s.name = "simple-templater"
  s.version = SimpleTemplater::VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/simple-templater"
  s.summary = "SimpleTemplater is dead-simple solution for creating generators."
  s.description = "SimpleTemplater is dead-simple solution for creating generators. It strongly uses convention over configuration, so you don't have to write loads of code to generate one stupid plain text README."
  s.cert_chain = nil
  s.email = Base64.decode64("c3Rhc3RueUAxMDFpZGVhcy5jeg==\n")
  s.has_rdoc = true

  # files
  s.files = `git ls-files`.split("\n")

  Dir["bin/*"].map(&File.method(:basename))
  s.default_executable = "simple-templater"
  s.require_paths = ["lib"]

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new("~> 1.9")

  # runtime dependencies
  s.add_dependency "cli"
  s.add_dependency "term-ansicolor"
  s.add_dependency "erubis" # for generators

  # development dependencies
  # use gem install simple-templater --development if you want to install them
  # s.add_development_dependency "erubis" # for generators

  begin
    require "changelog"
  rescue LoadError
    warn "You have to have changelog gem installed for post install message"
  else
    s.post_install_message = CHANGELOG.new.version_changes
  end

  # RubyForge
  s.rubyforge_project = "simple-templater"
end
