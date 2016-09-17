#!/usr/bin/env ruby
# encoding: utf-8

# === Usage ===
# 1) ./bin/init.rb Run as a Ruby console.
# 2) Require from another Ruby script to set up the environment.

# === Environment ===
# Load .env in case this is not run as one of the foreman processes.
env_path = File.expand_path("../../.env", __FILE__)

unless File.exist?(env_path)
  abort "Please run ./tasks.rb env first!"
end

# TODO: Unless loaded from config.ru
File.foreach(env_path) do |line|
  key, value = line.split("=")
  puts "~ ENV #{key} -> #{value}"
  ENV[key] = value
end

# Extend $LOAD_PATH.
# We don't have to use bundle exec thanks to that.
require "bundler"
Bundler.setup(:default, ENV["RACK_ENV"])

unless ENV["RACK_ENV"] == "production"
  require "pry"
end

# === Console (run ./bin/init.rb). ===
if __FILE__ == $0
  require "pry" # In this case even in production.
  binding.pry
end
