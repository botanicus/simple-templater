# encoding: utf-8

# require "simple-templater/hooks/preprocess/github"
# require "simple-templater/hooks/preprocess/full_name"
#
# # This hook will be executed before templater start to generate new files.
# # It runs in context of current generator object.
#
hook do |generator, context|
#   # simple-templater create rango --full-name="Jakub Stastny"
#   generator.before Hooks::FullName, Hooks::GithubRepository, Hooks::GithubUser
#   context[:constant] = context[:name].camel_case
  context[:ruby_version] ||= "1.9.3"
end
