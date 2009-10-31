# encoding: utf-8

module SimpleTemplater
  module ArgvParsingMixin
    def parse!
      self.inject(Hash.new) do |options, argument|
        case argument
        when /^--no-([^=]+)$/ # --no-git-repository
          options[$1.gsub("-", "_").to_sym] = false
        when /^--([^=]+)$/    # --git-repository
          options[$1.gsub("-", "_").to_sym] = true
        when /^--([^=]+)=([^,]+)$/ # --controller=post
          key, value = $1, $2
          options[key.gsub("-", "_").to_sym] = value.dup
        when /^--([^=]+)=(.+)$/    # --controllers=posts,comments
          key, value = $1, $2
          options[key.gsub("-", "_").to_sym] = value.split(",")
        else
          raise "Parsing failed on: #{argument}"
        end
        options
      end
    end
  end
end
