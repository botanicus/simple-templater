# encoding: utf-8

require "logger"
require_relative "../spec_helper"
require "simple-templater/main"

describe SimpleTemplater::Main do
  before(:each) do
    @templater = SimpleTemplater::Main.new(:test)
  end

  describe ".new" do
    it "should set scope" do
      @templater.scope.should eql(:test)
    end
  end

  describe "#generators" do
    it "should be empty hash if there are no generators" do
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
      @templater.find(:test).should be_kind_of(SimpleTemplater::Generator)
    end

    it "should work with a string as well" do
      @templater.find("test").should be_kind_of(SimpleTemplater::Generator)
    end
  end
end
