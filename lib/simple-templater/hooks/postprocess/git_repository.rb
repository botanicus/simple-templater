# encoding: utf-8

require "simple-templater/hooks/hook"

# run your generator with --git-repository resp. --no-git-repository
module SimpleTemplater::Hooks
  class GitRepository < Hook
    def question
      CLI.yes?("Do you want to initialize Git repozitory and do initial commit?")
    end

    def run
      sh "git init"
      sh "git add ."
      sh "git commit -a -m 'Initial import'"
    end
  end
end

__END__
OR

hook(:git_repository, "Do you want to initialize Git repozitory and do initial commit?") do |hook|
  # content of run method
end