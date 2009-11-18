# encoding: utf-8

require "rubygems"
require_relative "spec_helper"
require "simple-templater"

describe SimpleTemplater do
  before(:each) do
    Gem.clear_paths
    Gem.path.push(File.join(SPEC_ROOT, "stubs", "gems"))
  end

  describe "constants" do
    it "should provide VERSION string" do
      SimpleTemplater::VERSION.should match(/^\d+\.\d+\.\d+$/)
    end

    describe "SimpleTemplater::GeneratorNotFound" do
      it "should be defined as a constant" do
        SimpleTemplater.constants.should include(:GeneratorNotFound)
      end

      it "should be an exception class" do
        lambda { raise SimpleTemplater::GeneratorNotFound }.should_not raise_error(TypeError)
      end
    end

    describe ".scope(scope, &block)" do
      # TODO
    end

    describe ".register(name, path)" do
      # TODO
    end

    describe ".discover!(scope)" do
      it "should go through all the gems and find the generators" do
        SimpleTemplater.scopes.clear
        SimpleTemplater.discover!(:test)
        SimpleTemplater.scopes.should have_key(:test)
      end

      it "should not reset SimpleTemplater.scopes, so I can load local scope when I do local development" do
        load File.join(SPEC_ROOT, "stubs", "simple-templater.scope")
        SimpleTemplater.discover!(:test)
        SimpleTemplater.scopes.should have_key(:local)
      end
    end

    describe ".logger" do
      it "should set default logger" do
        [:info, :debug, :error, :fatal].each do |method|
          SimpleTemplater.logger.should respond_to(method)
        end
      end
    end
  end
end
