# encoding: utf-8

require "ostruct"
require_relative "../../spec_helper"
require "rubyexts/capture_io"
require "simple-templater/hooks/hook"

# factories
module SimpleTemplater::Hooks
  class Empty < Hook
  end

  class Test < Hook
    def question
      CLI.yes?("Do you hear me?")
    end

    def run
      puts "Done"
    end
  end
end

describe SimpleTemplater::Hooks::Hook do
  def capture(default = "X\n", &block)
    @output = STDOUT.capture do
      @returned = STDIN.capture(default, &block)
    end
    OpenStruct.new(returned: @returned, output: @output)
  end

  include SimpleTemplater::Hooks
  describe ".find" do
    it "should be nil if given hook doesn't exist" do
      Hook.find(:whatever).should be_nil
    end

    it "should find hook with :test key" do
      hook = Hook.find(:test).new(Hash.new)
      hook.should respond_to(:run)
      hook.should respond_to(:question)
    end
  end

  describe ".invoke" do
    describe "with context from ARGV" do
      before(:each) do
        @hook = Test.new(Hash.new)
        Test.stub!(:new).and_return(@hook)
      end

      it "should call #run method" do
        @hook.should_receive(:run)
        capture { Test.invoke(test: true) }
      end

      it "should not call #run method if the argument is negative" do
        pending
        @hook.should_not_receive(:run)
        capture { Test.invoke(test: false) }
      end
    end

    describe "without context from ARGV" do
      it "should print question with suggestions how user can respond" do
        output = capture("y\n") { Test.invoke(Hash.new) }.output
        regexp = Regexp.new(Regexp.quote("Do you hear me? [Y/n]"))
        output.should match(regexp)
      end

      it "should take y as true" do
        returned = capture("y\n") { Test.invoke(Hash.new) }.returned
        returned.should be_true
      end

      it "should take n as false" do
        returned = capture("n\n") { Test.invoke(Hash.new) }.returned
        returned.should be_false
      end
    end
  end

  describe "instance methods" do
    before(:each) do
      @hook = Hook.find(:empty).new(Hash.new)
    end

    describe "#key" do
      it "should be symbol created from snakecased name of class" do
        @hook.key.should eql(:empty)
      end
    end

    describe "#run" do
      it "should raise NotImplementedError by default" do
        lambda { @hook.run }.should raise_error(NotImplementedError)
      end
    end
  end
end
