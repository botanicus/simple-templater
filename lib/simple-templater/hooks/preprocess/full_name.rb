# encoding: utf-8

require "simple-templater/hooks/hook"

# run your generator with --name="Jakub Stastny"
module SimpleTemplater::Hooks
  class FullName < Hook
    def question
      name = ENV["USER"]
      CLI.yes?("Input your name or press enter if '#{name}' is OK", default: name)
    end

    def run
      self.context.reverse_merge!(self.key => self.reply)
    end
  end
end
