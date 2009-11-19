# encoding: utf-8

require "fileutils"
require "rubyexts/capture_io"
require_relative "../../../spec_helper"
require "simple-templater/hooks/postprocess/git_repository"

describe SimpleTemplater::Hooks::GitRepository do
  before(:each) do
    @hook = SimpleTemplater::Hooks::GitRepository.new(Hash.new)
    @repo = File.join(SPEC_ROOT, "stubs", "repository")
  end

  after(:each) do
    FileUtils.rm_r(@repo)
  end

  it "should create .git directory" do
    Dir.mkdir(@repo) # we are using fakefs so we don't have to remove it
    Dir.chdir(@repo) do
      STDOUT.capture { @hook.run } # don't show output, just do it
      Dir.exist?(File.join(@repo, ".git")).should be_true
    end
  end
end
