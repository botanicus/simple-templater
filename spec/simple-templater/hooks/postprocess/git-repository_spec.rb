# encoding: utf-8

require_relative "../../../spec_helper"
require "simple-templater/hooks/postprocess/git-repository"

describe SimpleTemplater::Hooks::GitRepository do
  before(:each) do
    @hook = SimpleTemplater::Hooks::GitRepository.new(Array.new)
    @repo = File.join(SPEC_ROOT, "stubs", "repository")
  end
  
  it "should create .git directory" do
    Dir.mkdir(@repo) # we are using fakefs so we don't have to remove it
    Dir.chdir(@repo) do
      @hook.run
      Dir.exist?(File.join(@repo, ".git")).should be_true
    end
  end
end
