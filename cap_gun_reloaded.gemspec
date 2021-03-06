# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cap_gun_reloaded}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob Sanheim", "Muness Alrubaie", "Relevance", "Leigh Caplan"]
  s.date = %q{2009-06-21}
  s.description = %q{Super simple capistrano deployment notifications.}
  s.email = %q{opensource@thinkrelevance.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".autotest",
     ".gitignore",
     "CHANGELOG",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "cap_gun_reloaded.gemspec",
     "examples/cap_gun_example.rb",
     "examples/example_helper.rb",
     "examples/presenter_example.rb",
     "init.rb",
     "install.rb",
     "lib/cap_gun_reloaded.rb",
     "lib/cap_gun/presenter.rb",
     "manifest.txt",
     "tasks/cap_bot_tasks.rake",
     "vendor/action_mailer_tls/README",
     "vendor/action_mailer_tls/init.rb",
     "vendor/action_mailer_tls/lib/smtp_tls.rb",
     "vendor/action_mailer_tls/sample/mailer.yml.sample",
     "vendor/action_mailer_tls/sample/smtp_gmail.rb",
     "version.yml"
  ]
  s.homepage = %q{http://github.com/texel/cap_gun_reloaded}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Bang! You're deployed. And you work with Onehub's deploy strategy!}
  s.test_files = [
    "examples/cap_gun_example.rb",
     "examples/example_helper.rb",
     "examples/presenter_example.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<spicycode-micronaut>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<spicycode-micronaut>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<spicycode-micronaut>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
