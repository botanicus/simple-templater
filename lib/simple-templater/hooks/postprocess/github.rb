# encoding: utf-8

# run your generator with --github resp. --no-github
if identificator(:github).yes?("Do you want to create #{@generator.project_name} on GitHub?")
  begin
    require "github"
  rescue LoadError
    raise SimpleTemplater::SkipHookError, "You have to have github gem installed"
  end
end
