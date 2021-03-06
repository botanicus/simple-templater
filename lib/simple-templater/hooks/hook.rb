# encoding: utf-8

require "simple-templater/argv_parsing"

# When generator runs:
# ARGV.extend(ArgvParsingMixin)
# options = ARGV.parse!
# options.each do |key, value|
#   hook = SimpleTemplater::Hooks.find(key, value)
#   hook.run
# end
class SimpleTemplater
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
      def self.hooks
        @@hooks ||= Array.new
      end

      def self.find(key)
        self.hooks.find { |hook| hook.name.split("::").last.snake_case.to_sym == key }
      end

      def self.inherited(klass)
        self.hooks.push(klass)
      end

      def self.invoke(context)
        hook = self.new(context)
        if hook.will_run?
          puts "Running hook #{self}"
          hook.run
          return true
        else
          puts "Skipping hook #{self}"
          return false
        end
      end

      attr_reader :context, :reply
      def initialize(context)
        @context = context
      end

      def key
        self.class.name.split("::").last.snake_case.to_sym
      end

      def will_run?
        return @reply unless @reply.nil?
        if self.context.has_key?(key)
          @reply = self.context[key]
        else
          @reply = self.question
        end
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
