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
          p [$1, $2, $&]
          options[$1.gsub("-", "_").to_sym] = $2.dup
        when /^--([^=]+)=(.+)$/    # --controllers=posts,comments
          p [$1, $2, $&]
          options[$1.gsub("-", "_").to_sym] = $2.split(",")
        else
          raise "Parsing failed on: #{argument}"
        end
        options
      end
    end
  end
end
