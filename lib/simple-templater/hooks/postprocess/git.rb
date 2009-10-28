# encoding: utf-8

# run your generator with --git-repository resp. --no-git-repository
if yes?(:git_repository, "Do you want to initialize Git repozitory and do initial commit?")
  sh "git init"
  sh "git add ."
  sh "git commit -a -m 'Initial import'"
end
