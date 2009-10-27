require_relative "spec_helper"
require "cli"

describe CLI do
  describe "yes?" do
    it "should print question to the STDOUT" do
      CLI.yes?("Do you like CLI?")
    end
    
    it "should print wait for response" do
      CLI.yes?("Do you like CLI?")
    end

    it "should set 'yes' as default option" do
      CLI.yes?("Do you like CLI?")
    end

    it "should take :default option as default if it's provided" do
      CLI.yes?("Do you like CLI?", default: false).should be_false
    end
    
    it "should print sown Y/n if default is set to true" do
      CLI.yes?("Do you like CLI?").should match("Y/n")
    end
    
    it "should print sown N/y if default is set to true" do
      CLI.yes?("Do you like CLI?", default: false).should match("N/y")
    end
  end

  describe "ask" do
    it "should print question to the STDOUT" do
      CLI.ask("How are you?")
    end
    
    it "should print wait for response" do
      CLI.ask("How are you?")
    end

    it "should set 'yes' as default option" do
      CLI.ask("How are you?")
    end

    it "should take :default option as default if it's provided" do
      CLI.ask("How are you?", default: false).should be_false
    end
    
    it "should print sown Y/n if default is set to true" do
      CLI.ask("How are you?").should match("Y/n")
    end
    
    it "should print sown N/y if default is set to true" do
      CLI.ask("How are you?", default: false).should match("N/y")
    end
  end
end
