# encoding: utf-8

require_relative "../spec_helper"
require "simple-templater/main"

describe SimpleTemplater::Main do
  before(:each) do
    @templater = SimpleTemplater::Main.new(:test)
  end
  
  describe ".new" do
    it "should set logger if it's provided as second argument" do
      logger    = Logger.new(STDOUT)
      templater = SimpleTemplater::Main.new(:test, logger)
      templater.logger.should equal(logger)
    end
    
    it "should set default logger if second argument isn't provided" do
      [:info, :debug, :error, :fatal].each do |method|
        @templater.logger.should respond_to(method)
      end
    end

    it "should set scope" do
      @templater.scope.should eql(:test)
    end
  end
  
  describe "#generators" do
    it "should be hash of {name: path}" do
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
      -> { @templater.register(:test_generator, "/a/b/c/d/whatever") }.should raise_error(SimpleTemplater::GeneratorNotFound)
    end
    
    it "should push values to the generators hash if the path exists" do
      path = File.join(SPEC_ROOT, "stubs", "test_generator")
      @templater.register(:test_generator, path)
      @templater.generators[:test_generator].should eql(path)
    end
  end
end
