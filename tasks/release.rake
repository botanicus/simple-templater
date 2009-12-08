# encoding: utf-8

desc "Release new version of simple-templater"
task release: ["deps.rip", "version:increase", "release:tag", "release:gemcutter"]

namespace :version do
  task :increase do
    puts "Which version are you just releasing (previous version is #{SimpleTemplater::VERSION})"
    version = STDIN.gets.chomp
    File.open("lib/simple-templater/version.rb", "w") do |file|
      file.puts <<-EOF
# encoding: utf-8

# NOTE: Do not edit this file manually, this
# file is regenerated by task rake version:increase
module SimpleTemplater
  VERSION ||= "#{version}"
end
      EOF
    end

    SimpleTemplater.const_set("VERSION", version) # so other release tasks will work
    sh "git commit lib/simple-templater/version.rb -m 'Increased version to #{version}'"
  end
end

namespace :release do
  desc "Create Git tag"
  task :tag do
    puts "Creating new git tag #{SimpleTemplater::VERSION} and pushing it online ..."
    sh "git tag -a -m 'Version #{SimpleTemplater::VERSION}' #{SimpleTemplater::VERSION}"
    sh "git push --tags"
    puts "Tag #{SimpleTemplater::VERSION} was created and pushed to GitHub."
  end

  desc "Push gem to Gemcutter"
  task :gemcutter => :build do
    puts "Pushing to Gemcutter ..."
    sh "gem push #{Dir["*.gem"].last}"
  end
end

desc "Create and push prerelease gem"
task :prerelease => "build:prerelease" do
  puts "Pushing to Gemcutter ..."
  sh "gem push #{Dir["*.pre.gem"].last}"
end

dependencies = FileList["vendor/*/.git"].sub(/\/\.git$/, "")

desc "Regenerate deps.rip"
file "deps.rip" => dependencies do
  commits = Hash.new
  commits = dependencies.inject(Hash.new) do |hash, path|
    Dir.chdir(path) do
      revision = %x(git show | head -1).chomp.sub("commit ", "")
      hash[File.basename(path)] = revision
      hash
    end
  end
  template = File.read("deps.rip.rbe")
  deps_rip = eval("%Q{#{template}}")
  File.open("deps.rip", "w") do |file|
    file.puts(deps_rip)
  end
  sh "chmod +x deps.rip"
  sh "git commit deps.rip -m 'Updated deps.rip'"
end
