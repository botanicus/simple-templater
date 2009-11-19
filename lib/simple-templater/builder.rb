# encoding: utf-8

require "erubis"
require "fileutils"
require "tempfile"
require "find"
require "simple-templater/helpers"

# @since 0.0.3
# @example
#   SimpleTemplater::Builder.create("my_generator_dir", user: "botanicus", constant: -> { |argv| argv.first.camel_case })
class SimpleTemplater
  class Builder
    def self.create(*args)
      templater = self.new(*args)
      SimpleTemplater.logger.debug("Context: #{templater.context.inspect}")
      templater.create
    end

    attr_accessor :context
    def initialize(content_dir, context = ARGV.parse!)
      @content_dir, @context = content_dir, context.reverse_merge(name: File.basename(Dir.pwd))
    end

    def create
      Find.find(@content_dir) do |template|
        file = self.expand_path(template)
        next if template == @content_dir
        if File.file?(template)
          proceed_file(template, file)
        else
          unless Dir.exist?(file)
            SimpleTemplater.logger.debug("[MKDIR] #{file}")
            FileUtils.mkdir_p(file)
          end
        end
      end
    end

    protected
    # replace %variable% in file path
    # %name%_controller.rb => application_controller.rb
    def expand_path(file)
      file = self.location(file).sub(/\.rbt$/, "")
      @context.each do |key, value|
        file.gsub!(/%#{Regexp::quote(key)}%/, value.to_s)
      end
      return file
    end

    def location(file)
      file.sub(%r[^#{Regexp::quote(@content_dir)}/?], "")
    end

    def proceed_file(template, file)
      FileUtils.mkdir_p(File.dirname(file))
      if template.end_with?(".rbt")
        if File.exist?(file)
          SimpleTemplater.logger.debug("[RETEMPLATE] #{file} (from #{template})")
        else
          SimpleTemplater.logger.debug("[TEMPLATE] #{file} (from #{template})")
        end
        File.open(file, "w") do |file|
          eruby = Erubis::Eruby.new(File.read(template))
          context = Erubis::Context.new(@context)
          context.extend(SimpleTemplater::Helpers)
          begin
            output = eruby.evaluate(context)
          rescue Exception => exception
            SimpleTemplater.logger.error("Exception occured in template #{template}: #{exception.message}")
          end
          file.print(output)
        end
      else # just copy
        if File.exist?(file)
          SimpleTemplater.logger.debug("[RECOPY] #{file} (from #{template})")
          FileUtils.cp_f(template, file)
        else
          SimpleTemplater.logger.debug("[COPY] #{file} (from #{template})")
          FileUtils.cp(template, file)
        end
      end
    end
  end
end
