# encoding: utf-8

require_relative "../spec_helper"
require "simple-templater/generator"

describe SimpleTemplater::Generator do
  before(:each) do
    @generator_dir = File.join(SPEC_ROOT, "stubs", "test_generator", "stubs", "test")
    @generator = SimpleTemplater::Generator.new(:test, @generator_dir)
  end

  describe "#initialize" do
    it "should take first argument as a name" do
      @generator.name.should eql(:test)
    end

    it "should to_sym" do
      generator = SimpleTemplater::Generator.new("test", @generator_dir)
      generator.name.should eql(:test)
    end

    it "should take second argument as a path" do
      @generator.path.should eql(@generator_dir)
    end

    it "should raise an exception if path doesn't exist" do
      -> { SimpleTemplater::Generator.new(:test, "/i/do/not/exist") }.should raise_error(SimpleTemplater::GeneratorNotFound)
    end
  end
end
