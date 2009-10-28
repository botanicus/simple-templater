#!/usr/bin/env gem1.9 build
# encoding: utf-8

Dir[File.join(File.dirname(__FILE__), "vendor", "*")].each do |path|
  if File.directory?(path) && Dir["#{path}/*"].empty?
    warn "Dependency #{File.basename(path)} in vendor seems to be empty. Run git submodule init && git submodule update to checkout it."
  elsif File.directory?(path) && File.directory?(File.join(path, "lib"))
    $:.unshift File.join(path, "lib")
  end
end

# Run thor package:gem or gem build simple-templater.gemspec
# NOTE: we can't use require_relative because when we run gem build, it use eval for executing this file
require File.join(File.dirname(__FILE__), "lib", "simple-templater")

Gem::Specification.new do |s|
  s.name = "simple-templater"
  s.version = SimpleTemplater::VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/simple-templater"
  s.summary = "SimpleTemplater is dead-simple solution for creating generators."
  s.description = "SimpleTemplater is dead-simple solution for creating generators. It strongly uses convention over configuration, so you don't have to write loads of code to generate one stupid plain text README."
  s.cert_chain = nil
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")
  s.has_rdoc = true

  # files
  s.files = Dir.glob("**/*") - Dir.glob("pkg/*")
  s.executables = ["simple-templater"]
  s.default_executable = "simple-templater"
  s.require_paths = ["lib"]

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new(">= 1.9.1")

  # runtime dependencies
  s.add_dependency "rubyexts"

  # development dependencies
  # use gem install simple-templater --development if you want to install them
  s.add_development_dependency "erubis" # for generators

  # RubyForge
  # s.rubyforge_project = "simple-templater"
end
