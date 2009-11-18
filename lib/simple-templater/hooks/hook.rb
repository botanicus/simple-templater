# encoding: utf-8

require "rubyexts/string" # String#snake_case
require "rubyexts/class"

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

      def initialize(argv)
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
