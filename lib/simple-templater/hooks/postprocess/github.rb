# encoding: utf-8

require "simple-templater/hooks/hook"

# run your generator with --github resp. --no-github
module SimpleTemplater::Hooks
  class Github < Hook
    def setup
      require "github"
    rescue LoadError
      raise SimpleTemplater::SkipHookError, "You have to have github gem installed"
    end

    def run
      if identificator(:github).yes?("Do you want to create #{@generator.project_name} on GitHub?")
        #
      end
    end
  end
end
