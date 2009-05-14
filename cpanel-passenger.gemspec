# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = %q{cpanel-passenger}
  s.version = '0.0.2'

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Hepworth"]
  s.date = %q{2009-05-14}
  s.default_executable = %q{cpanel_passenger}
  s.description = %q{This gem consists of a single script that enables a cpanel account to run a Ruby on Rails App. Many more improvements could/should be made to handle more cases.}
  s.email = ["paul@peppyheppy.com"]
  s.executables = ["cpanel_passenger"]
  s.extra_rdoc_files = ["Manifest.txt", "README.rdoc"]
  s.files = ["Manifest.txt", "README.rdoc", "Rakefile", "bin/cpanel_passenger", "lib/cpanel_passenger.rb", "lib/cpanel_passenger/cli.rb"]
  s.homepage = %q{http://github.com/peppyheppy/cpanel-passenger}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cpanel-passenger}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{This gem consists of a single script that enables a cpanel account to run a Ruby on Rails App}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.4.1"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
