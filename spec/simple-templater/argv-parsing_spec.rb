# encoding: utf-8

require_relative "../spec_helper"
require "simple-templater/argv-parsing"

describe SimpleTemplater::ArgvParsingMixin do
  def parse(*args)
    args.extend(SimpleTemplater::ArgvParsingMixin)
    args.parse!
  end

  describe "#parse!" do
    it "should returns Hash" do
      parse.should be_kind_of(Hash)
    end

    it "should parse --git-repository to {git_repository: true}" do
      options = parse("--git-repository")
      options[:git_repository].should be_true
    end

    it "should parse --no-github to {github: false}" do
      options = parse("--no-github")
      options[:github].should be_false
    end

    it "should parse --controller=posts to {controller: 'posts'}" do
      options = parse("--controller=posts")
      options[:controller].should eql("posts")
    end

    it "should parse --models=post,comment to {models: ['post', 'comment']}" do
      options = parse("--models=post,comment")
      options[:models].should eql(["post", "comment"])
    end
  end
end
