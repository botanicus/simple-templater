# encoding: utf-8

require "rbconfig"

class SimpleTemplater
  module Helpers
    extend self

    def shebang(executable = ruby_basename, *args)
      if RUBY_PLATFORM.match(/darwin/)
        self.env_shebang(executable, args)
      else
        self.plain_shebang(executable, args)
      end
    end

    def plain_shebang(executable = ruby_basename, *args)
      "#!#{executable} #{args.join(" ")}".chomp(" ")
    end

    def env_shebang(executable = ruby_basename, *args)
      "#!/usr/bin/env #{executable} #{args.join(" ")}".chomp(" ")
    end

    def rubypath
      File.join(RbConfig::CONFIG["bindir"], self.ruby_basename)
    end

    def ruby_basename
      RbConfig::CONFIG["RUBY_INSTALL_NAME"]
    end
  end
end
