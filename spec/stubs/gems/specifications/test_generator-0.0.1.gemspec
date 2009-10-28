# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{test_generator}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jakub \305\240\305\245astn\303\275 aka Botanicus"]
  s.cert_chain = nil
  s.date = %q{2009-10-28}
  s.description = %q{}
  s.email = %q{knava.bestvinensis@gmail.com}
  s.files = ["simple-templater.gemspec", "simple-templater.scope", "stubs/content/%name%1_test.rb.rbt", "stubs/content/%name%_test.rb", "stubs/content/README.textile", "stubs/content/script.rb.rbt"]
  s.homepage = %q{http://github.com/botanicus/simple-templater}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Just a stub for SimpleTemplater}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
