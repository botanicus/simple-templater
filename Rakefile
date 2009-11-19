#!/usr/bin/env rake1.9
# encoding: utf-8

require_relative "lib/simple-templater"

# http://support.runcoderun.com/faqs/builds/how-do-i-run-rake-with-trace-enabled
Rake.application.options.trace = true

task :setup => ["submodules:init"]

namespace :submodules do
  desc "Init submodules"
  task :init do
    sh "git submodule init"
    sh "git submodule update"
  end

  desc "Update submodules"
  task :update => :init do
    Dir["vendor/*"].each do |path|
      if File.directory?(path) && File.directory?(File.join(path, ".git"))
        Dir.chdir(path) do
          puts "=> #{path}"
          puts %x[git checkout master]
          puts %x[git fetch]
          puts %x[git reset origin/master --hard]
          puts
        end
      end
    end
  end
end

task :gem do
  sh "gem build simple-templater.gemspec"
end

desc "Release version #{SimpleTemplater::VERSION}"
task release: ["release:tag", "release:push"]

namespace :release do
  desc "Create Git tag #{SimpleTemplater::VERSION}"
  task :tag do
    puts "Creating new git tag #{SimpleTemplater::VERSION} and pushing it online ..."
    sh "git tag -a -m 'Version #{SimpleTemplater::VERSION}' #{SimpleTemplater::VERSION}"
    sh "git push --tags"
    puts "Tag #{SimpleTemplater::VERSION} was created and pushed to GitHub."
  end

  desc "Push gem to Gemcutter"
  task :gemcutter => :gem do
    puts "Pushing to Gemcutter ..."
    sh "gem push #{gem}"
  end
end

desc "Run specs"
task :default => :setup do
  rubylib = (ENV["RUBYLIB"] || String.new).split(":")
  libdirs = Dir["vendor/*/lib"]
  ENV["RUBYLIB"] = (libdirs + rubylib).join(":")
  exec "./script/spec --options spec/spec.opts spec"
end
