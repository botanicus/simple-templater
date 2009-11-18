# encoding: utf-8

require_relative "spec_helper"
require "simple-templater"

describe SimpleTemplater do
  before(:each) do
    Gem.path.clear
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
      
      it "should be exception class" do
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
        pending "Make SimpleTemplater.discover! working"
        SimpleTemplater.scopes.clear
        SimpleTemplater.discover!(:test_generator)
        SimpleTemplater.scopes.should_not be_empty
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
