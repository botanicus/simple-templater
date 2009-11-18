# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{test_generator}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.cert_chain = nil
  s.date = %q{2009-11-18}
  s.description = %q{}
  s.email = %q{knava.bestvinensis@gmail.com}
  s.files = ["simple-templater.scope", "stubs/test/content/%name%1_test.rb.rbt", "stubs/test/content/%name%_test.rb", "stubs/test/content/README.textile", "stubs/test/content/script.rb.rbt", "test_generator-0.0.1.gem", "test_generator.gemspec"]
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
