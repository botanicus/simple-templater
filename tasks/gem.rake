# encoding: utf-8

desc "Build the gem"
task :build do
  sh "gem build simple-templater.gemspec"
end

namespace :build do
  desc "Build the prerelease gem"
  task :prerelease do
    gemspec = "simple-templater.gemspec"
    content = File.read(gemspec)
    prename = "#{gemspec.split(".").first}.pre.gemspec"
    # 0.1.1 => 0.2
    version = SimpleTemplater::VERSION.sub(/^(\d+)\.(\d+).*$/) { "#$1.#{$2.to_i + 1}" }
    puts "Current #{SimpleTemplater::VERSION} => #{version} pre"
    File.open(prename, "w") do |file|
      file.puts(content.gsub(/(\w+::VERSION)/, "'#{version}.pre'"))
    end
    sh "gem build #{prename}"
    rm prename
  end
end
