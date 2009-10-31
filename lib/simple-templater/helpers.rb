# encoding: utf-8

require "rbconfig"
require "rubyexts/platform"

module SimpleTemplater
  module Helpers
    include RbConfig
    extend self

    def shebang(executable = rubypath, *args)
      if RubyExts::Platform.linux?
        self.plain_shebang(executable, args)
      else
        self.env_shebang(executable, args)
      end
    end

    def plain_shebang(executable = rubypath, *args)
      "#!#{executable} #{args.join(" ")}".chomp(" ")
    end

    def env_shebang(executable = ruby_basename, *args)
      "#!/usr/bin/env #{executable} #{args.join(" ")}".chomp(" ")
    end

    def rubypath
      File.join(CONFIG["bindir"], self.ruby_basename)
    end

    def ruby_basename
      CONFIG["RUBY_INSTALL_NAME"]
    end
  end
end
