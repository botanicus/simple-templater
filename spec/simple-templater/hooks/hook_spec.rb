# encoding: utf-8

require_relative "../../spec_helper"
require "simple-templater/hooks/hook"

# factories
module SimpleTemplater::Hooks
  class Test < Hook
  end
end

describe SimpleTemplater::Hooks::Hook do
  include SimpleTemplater::Hooks
  describe ".find" do
    it "should be nil if given hook doesn't exist" do
      Hook.find(:whatever).should be_nil
    end

    it "should find hook with :test key" do
      hook = Hook.find(:test).new
      hook.should respond_to(:run)
      hook.should respond_to(:question)
    end
  end

  describe ".invoke" do
    describe "with ARGV" do
      it "should return true if" do
        ARGV.clear.push("--git-repository")
        Test.invoke.should be_true
      end

      it "should return false if" do
        ARGV.clear.push("--no-git-repository")
        Test.invoke.should be_false
      end
    end

    describe "without ARGV" do
      it "should print question with suggestions how user can respond" do
        pending "How can I test if it ask for y/n?"
        ARGV.clear
        Test.invoke
      end

      it "should take y as true" do
        pending "How can I test if it ask for y/n?"
        Test.invoke.should be_false
      end

      it "should take n as false" do
        pending "How can I test if it ask for y/n?"
        Test.invoke.should be_false
      end
    end
  end

  describe "instance methods" do
    before(:each) do
      @hook = Hook.find(:test).new
    end

    describe "#key" do
      it "should be symbol created from snakecased name of class" do
        @hook.key.should eql(:test)
      end
    end

    describe "#run" do
      it "should raise NotImplementedError by default" do
        lambda { @hook.run }.should raise_error(NotImplementedError)
      end
    end
  end
end
