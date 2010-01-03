# encoding: utf-8

require "erubis"
require "fileutils"
require "tempfile"
require "find"
require "simple-templater/helpers"

module FileUtils
  def self.cp_f(source, target)
    sh "cp -f '#{source}' '#{target}'"
    # self.rm target
    # self.cp source, target
  end
end

# @since 0.0.3
# @example
#   SimpleTemplater::Builder.create("my_generator_dir", user: "botanicus", constant: -> { |argv| argv.first.camel_case })
class SimpleTemplater
  class Builder
    def self.create(*args)
      templater = self.new(*args)
      puts "Context: #{templater.context.inspect}"
      templater.create
    end

    attr_accessor :context
    def initialize(content_dir, context = Hash.new)
      @content_dir, @context = content_dir, context
    end

    def create
      Find.find(@content_dir) do |template|
        file = self.expand_path(template)
        next if template == @content_dir
        proceed(template, file)
      end
    end

    protected
    # %name%_controller.rb => application_controller.rb
    def expand_path(file)
      self.location(file).sub(/\.rbt$/, "")
    end

    def location(file)
      file.sub(%r[^#{Regexp::quote(@content_dir)}/?], "")
    end

    # TODO: %a%/%b% etc, now it can handle just one %var%
    def proceed(template, file)
      # OK, this is a bit tricky, but it works
      # == TEMPLATE ==   | == CONTEXT ==             | == OUTPUT ==
      # config/%user%.rb | {user: "botanicus"}       | config/botanicus.rb
      # %model%.rb       | {models: ["tag", "post"]} | tag.rb, post.rb
      if template.match(/%(\w+)%/)
        singular, plural = $1.to_sym, "#{$1}s".to_sym # TODO: use inflector
        if self.context.has_key?(singular)
          target = file.sub(/%(\w+)%/, self.context[singular])
          proceed_file(template, target)
        elsif self.context.has_key?(plural)
          variables = self.context[plural] || Array.new
          variables.each do |variable|
            target = file.sub(/%(\w+)%/, variable)
            proceed_file(template, target, {singular => variable})
          end
        else
          raise "Context #{self.context.inspect} doesn't have key #{singular} or #{plural}"
        end
      else
        proceed_file(template, file)
      end
    end

    def proceed_file(template, file, local_context = Hash.new)
      puts("Local context: #{local_context.inspect}") unless local_context.empty?
      FileUtils.mkdir_p(File.dirname(file))

      if File.directory?(template)
        FileUtils.rm_rf(file) # directory include its content
        FileUtils.mkdir(file)
      end

      if template.end_with?(".rbt")
        if File.exist?(file)
          puts "[RETEMPLATE] #{file} (from #{template})"
        else
          puts "[TEMPLATE] #{file} (from #{template})"
        end
        File.open(file, "w") do |file|
          eruby = Erubis::Eruby.new(File.read(template))
          context = Erubis::Context.new(@context.merge(local_context))
          context.extend(SimpleTemplater::Helpers)
          begin
            output = eruby.evaluate(context)
          rescue Exception => exception
            abort "Exception occured in template #{template}: #{exception.message}"
          end
          file.print(output)
        end
      else # just copy
        if File.directory?(file)
          # do nothing
          # it shouldn't get here never, we have File.directory? above
        elsif File.file?(file)
          puts "[RECOPY] #{file} (from #{template})"
          FileUtils.cp_f(template, file)
        else
          puts "[COPY] #{file} (from #{template})"
          FileUtils.cp(template, file)
        end
      end

      copy_permissions template, file
    end

    def copy_permissions(template, file) # TODO: reimplement, this is crap
      File.chmod(0755, file) if File.executable?(template)
    end
  end

  class FlatBuilder < Builder
    attr_reader :source, :target
    def initialize(source, target, context = Hash.new)
      @source, @target, @context = source, target, context
      @content_dir = File.expand_path(File.join(source, ".."))
    end

    def create
      proceed(self.source, self.target)
    end
  end
end
