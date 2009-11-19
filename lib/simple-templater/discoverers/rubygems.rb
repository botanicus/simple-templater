# encoding: utf-8

# Mostly stolen from Templater http://github.com/jnicklas/templater

# This provides a hook system which programs that use Templater can use to discover generators
# installed through gems. This requires two separate things, the Templater-using progrma will
# have to call the #discover! method giving a scope, like this:
#
#     Templater::Discovery.discover!("name-of-scope")
#
# Where "name-of-scope" should be a string that uniquely identifies your program. Any gem wishing
# to then add a generator, that is automatically picked up, will then need to add a simple-templater.scope
# file at the root of the project (don't forget to add it to the gem's manifest of files).
#
#     - lib /
#     - spec /
#     - Rakefile
#     - simple-templater.scope
#
# This file should look something like this:
#
#     SimpleTemplater.scope(:rango) do
#       root = File.dirname(__FILE__)
#       Dir["#{root}/stubs/*"].each do |stub_dir|
#         if File.directory?(stub_dir)
#           SimpleTemplater.register(:rango, stub_dir)
#         end
#       end
#     end
#
# Multiple scopes can be added to the same simple-templater.scope file for use with different generator
# programs.

class SimpleTemplater
  class RubyGems < Discoverer
    # Searches installed gems for simple-templater.scope files and loads all code blocks in them that match
    # the given scope.
    #
    # === Parameters
    # scope<String>:: The name of the scope to search for
    def run
      generator_files.each { |file| load file }
      if SimpleTemplater.scopes[self.scope]
        SimpleTemplater.scopes[self.scope].each do |block|
          begin
            block.call
          rescue Exception => exception
            warn "[Scope #{self.scope}] Exception #{exception.class}: #{exception} occured in scope file #{block.inspect}\n#{exception.backtrace.join("\n")}"
          end
        end
      end
    end

    def find_latest_gem_paths
      require "rubygems" unless defined?(Gem)
      # Minigems provides a simpler (and much faster) method for finding the
      # latest gems.
      if Gem.respond_to?(:latest_gem_paths)
        Gem.latest_gem_paths
      else
        gems = Gem.cache.inject(Hash.new) do |latest_gems, cache|
          name, gem = cache
          currently_latest = latest_gems[gem.name]
          latest_gems[gem.name] = gem if currently_latest.nil? or gem.version > currently_latest.version
          latest_gems
        end
        gems.values.map { |gem| gem.full_gem_path }
      end
    end

    def generator_files
      find_latest_gem_paths.inject(Array.new) do |files, gem_path|
        path = ::File.join(gem_path, "simple-templater.scope")
        files << path if ::File.file?(path)
        files
      end
    end
  end
end
