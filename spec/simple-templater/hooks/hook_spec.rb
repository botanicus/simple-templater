# encoding: utf-8

require_relative "../spec_helper"
require "simple-templater"

# factories
module SimpleTemplater::Hooks
  class TestHook < Hook
  end
end

describe SimpleTemplater::Hooks::Hook do
  include SimpleTemplater::Hooks
  describe ".find" do
    it "should find hook with :test key" do
      Hook.find(:test)
    end
  end
  
  describe "#key" do
    it "should be symbol created from snakecased name of class" do
      @hook.key.should eql(:test_hook)
    end
  end
  
  describe "#run" do
    it "should raise NotImplementedError by default" do
      lambda { @hook.run }.should raise_error(NotImplemented)
    end
  end
end
