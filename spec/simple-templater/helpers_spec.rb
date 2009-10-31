# encoding: utf-8

require_relative "../spec_helper"
require "simple-templater/helpers"

describe SimpleTemplater::Helpers do
  it "should works as a mixin but it's methods should be also available as module methods" do
    # SimpleTemplater::Helpers.shebang
  end

  describe "#shebang" do
    include SimpleTemplater::Helpers
    before(:each) do
      RubyExts::Platform.stub!(:linux?).and_return(true)
    end

    it "should generate shebang with path to executable on Linux" do
      shebang("ruby").should eql("#!ruby")
    end

    it "should generate shebang with /usr/bin/env on other platforms" do
      RubyExts::Platform.stub!(:linux?).and_return(false)
      shebang("ruby").should eql("#!/usr/bin/env ruby")
    end

    it "should take basename of current Ruby as a default executable" do
      pending "How to test it?"
      shebang.should eql("#!/usr/bin/env ruby")
    end

    it "should handle arguments for given executable" do
      shebang("ruby", "-w", "--disable-gems").should eql("#!ruby -w --disable-gems")
    end
  end

  describe "#plain_shebang" do
    include SimpleTemplater::Helpers
    it "should generate shebang with path to executable" do
      plain_shebang("ruby").should eql("#!ruby")
    end

    it "should take basename of current Ruby as a default executable" do
      pending "How to test it?"
      plain_shebang.should eql("#!/usr/bin/env ruby")
    end

    it "should handle arguments for given executable" do
      plain_shebang("ruby", "-w", "--disable-gems").should eql("#!ruby -w --disable-gems")
    end
  end

  describe "#env_shebang" do
    include SimpleTemplater::Helpers
    it "should generate shebang with /usr/bin/env" do
      env_shebang("ruby").should eql("#!/usr/bin/env ruby")
    end

    it "should take basename of current Ruby as a default executable" do
      pending "How to test it?"
      env_shebang.should eql("#!/usr/bin/env ruby")
    end

    it "should handle arguments for given executable" do
      env_shebang("ruby", "-w", "--disable-gems").should eql("#!/usr/bin/env ruby -w --disable-gems")
    end
  end

  describe "#rubypath" do
    include SimpleTemplater::Helpers
    it "should be full path to current Ruby" do
      pending "How to test it?"
    end
  end

  describe "#ruby_basename" do
    include SimpleTemplater::Helpers
    it "should be basename of current Ruby" do
      pending "How to test it?"
    end
  end
end
