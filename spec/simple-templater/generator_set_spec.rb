# encoding: utf-8

require_relative "../spec_helper"
require "simple-templater/generator_set"

describe SimpleTemplater::GeneratorSet do
  before(:each) do
    @generator_dir = File.join(SPEC_ROOT, "stubs", "test_generator", "stubs", "test")
    @set = SimpleTemplater::GeneratorSet.new(:test, @generator_dir)
  end

  describe "#initialize" do
    it "should take first argument as a name" do
      set = SimpleTemplater::GeneratorSet.new(:test)
      set.name.should eql(:test)
    end

    it "should take all others attributes as paths with generators" do
      set = SimpleTemplater::GeneratorSet.new(:test, @generator_dir)
      set.paths.should_not be_empty
    end

    it "should raise an exception if path doesn't exist" do
      -> { SimpleTemplater::GeneratorSet.new(:test, "/i/do/not/exist") }.should raise_error(SimpleTemplater::GeneratorNotFound)
    end

    it "should set paths to empty array if no paths specified" do
      set = SimpleTemplater::GeneratorSet.new(:test)
      set.stub!(:custom).and_return(Array.new)
      set.paths.should be_empty
    end
  end

  describe "#generators" do
    it "should should be an array with generators" do
      @set.generators.first.should be_kind_of(SimpleTemplater::Generator)
    end

    it "should be an empty array if there are no paths with generators" do
      @set.paths.clear
      @set.generators.should be_empty
    end
  end

  describe "#custom" do
    it "should returns an array with custom paths where user redefined the default generators" do
      pending "This will require FakeFS"
    end

    it "should be an empty array if no custom directories are available" do
      @set.custom.should be_empty
    end
  end
end
