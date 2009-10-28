require_relative "spec_helper"
require "simple-templater"

describe SimpleTemplater do
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
    
    describe ".scope" do
      # TODO
    end
    
    describe ".register" do
      # TODO
    end
    
    describe ".discover!" do
      # TODO
    end
  end
end
