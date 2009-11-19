# encoding: utf-8

require "rubyexts/string" # String#snake_case
require "rubyexts/class"
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
      cattr_reader :hooks
      @@hooks ||= Array.new
      def self.find(key)
        @@hooks.find { |hook| hook.name.split("::").last.snake_case.to_sym == key }
      end

      def self.inherited(klass)
        @@hooks.push(klass)
      end

      def self.invoke(context)
        self.new(context).tap do |hook|
          if hook.will_run?
            SimpleTemplater.logger.info("Running hook #{self}")
            hook.run
            return true
          else
            SimpleTemplater.logger.info("Skipping hook #{self}")
          end
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
        @reply ||= begin
          return self.context[key] unless self.context[key].nil?
          return self.question
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
