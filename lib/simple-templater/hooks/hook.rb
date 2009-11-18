# encoding: utf-8

require "rubyexts/string" # String#snake_case
require "rubyexts/class"
require "simple-templater/argv-parsing"

# When generator runs:
# ARGV.extend(ArgvParsingMixin)
# options = ARGV.parse!
# options.each do |key, value|
#   hook = SimpleTemplater::Hooks.find(key, value)
#   hook.run
# end
module SimpleTemplater
  module Hooks
    module DSL
      def hook(key, question, &block)
        Class.new(Hook.new) do
          def key() key; end
          def question() question; end
          def run() block.call; end
        end
      end
    end

    class Hook
      cattr_reader :hooks
      @@hooks ||= Array.new
      def self.find(key)
        @@hooks.find { |hook| hook.name.split("::").last.snake_case.to_sym == key }
      end

      def self.inherited(klass)
        @@hooks.push(klass)
      end

      def initialize
      end

      def self.invoke
        hook = self.new
        hook.run if hook.required_from_argv || hook.question
      end

      def required_from_argv
        ARGV.extend(SimpleTemplater::ArgvParsingMixin)
        options = ARGV.parse!
        options[key]
      end

      def key
        self.class.name.split("::").last.snake_case.to_sym
      end

      def question
        raise NotImplementedError, "Hook #{self.key} have to have implemented method #question"
      end

      def run
        raise NotImplementedError, "Hook #{self.key} have to have implemented method #run"
      end
    end
  end
end
