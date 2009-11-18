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
