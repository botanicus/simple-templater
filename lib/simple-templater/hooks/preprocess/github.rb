# encoding: utf-8

require "simple-templater/hooks/hook"

module SimpleTemplater::Hooks
  class GithubUser < Hook
    def question
      ENV["USER"] # don't bother users with asking, it's very likely that github username will be same as $USER variable. If not, user can specify it from CLI as --github-user=botanicus
    end

    def run
      self.context.reverse_merge!(self.key => self.reply)
    end
  end

  class GithubRepository < Hook
    def question
      self.context[:name] # don't bother users with asking, it's very likely that github username will be same as $USER variable. If not, user can specify it from CLI as --github-repository=simple-templater
    end

    def run
      self.context.reverse_merge!(self.key => self.reply)
    end
  end
end
