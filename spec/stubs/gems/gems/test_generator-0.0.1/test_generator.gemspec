#!/usr/bin/env gem1.9 build
# encoding: utf-8

# Run thor package:gem or gem build simple-templater.gemspec
# NOTE: we can't use require_relative because when we run gem build, it use eval for executing this file
Gem::Specification.new do |s|
  s.name = "test_generator"
  s.version = "0.0.1"
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/simple-templater"
  s.summary = "Just a stub for SimpleTemplater"
  s.description = "" # TODO: long description
  s.cert_chain = nil
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")
  s.has_rdoc = true

  # files
  s.files = Dir.glob("**/*")
  s.require_paths = ["lib"]
end
