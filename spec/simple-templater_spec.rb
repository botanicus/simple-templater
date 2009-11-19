# encoding: utf-8

require "logger"
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

describe SimpleTemplater do
  before(:each) do
    @templater = SimpleTemplater.new(:test)
  end

  describe ".new" do
    it "should set scope" do
      @templater.scope.should eql(:test)
    end
  end

  describe "#generators" do
    it "should be empty hash if there are no generators" do
      pending
      @templater.generators.should be_empty
      @templater.generators.should be_kind_of(Hash)
    end

    it "should be hash of {name: path}" do
      pending "Add generators"
      @templater.generators.should_not be_empty
      @templater.generators.each do |name, path|
        name.should be_kind_of(Symbol)
        File.directory?(path).should be_true
      end
    end
  end

  describe "#discover!" do
  end

  describe "#register(name, path)" do
    it "should raise GeneratorNotFound if path doesn't exist" do
      -> { @templater.register(:test, "/a/b/c/d/whatever") }.should raise_error(SimpleTemplater::GeneratorNotFound)
    end

    it "should push values to the generators hash if the path exists" do
      path = File.join(SPEC_ROOT, "stubs", "test_generator", "stubs", "test")
      -> { @templater.register(:test, path) }.should change { @templater.generators.length }.by(1)
    end
  end

  describe "#find(name)" do
    it "should return generator with responding name" do
      @templater.find(:test).should be_kind_of(SimpleTemplater::GeneratorSet)
    end

    it "should work with a string as well" do
      @templater.find("test").should be_kind_of(SimpleTemplater::GeneratorSet)
    end
  end
end
