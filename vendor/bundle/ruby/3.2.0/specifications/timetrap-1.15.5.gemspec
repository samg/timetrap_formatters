# -*- encoding: utf-8 -*-
# stub: timetrap 1.15.5 ruby lib

Gem::Specification.new do |s|
  s.name = "timetrap".freeze
  s.version = "1.15.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sam Goldstein".freeze]
  s.date = "2025-03-10"
  s.description = "Timetrap is a simple command line time tracker written in ruby. It provides an easy to use command line interface for tracking what you spend your time on.".freeze
  s.email = ["sgrock@gmail.org".freeze]
  s.executables = ["dev_t".freeze, "t".freeze, "timetrap".freeze]
  s.files = ["bin/dev_t".freeze, "bin/t".freeze, "bin/timetrap".freeze]
  s.homepage = "https://github.com/samg/timetrap".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Command line time tracker".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, ["~> 2.1"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.9.0"])
  s.add_development_dependency(%q<fakefs>.freeze, ["~> 0.20"])
  s.add_development_dependency(%q<icalendar>.freeze, ["~> 2.7"])
  s.add_development_dependency(%q<json>.freeze, ["~> 2.3"])
  s.add_runtime_dependency(%q<sequel>.freeze, ["~> 5.90.0"])
  s.add_runtime_dependency(%q<sqlite3>.freeze, ["~> 1.4"])
  s.add_runtime_dependency(%q<chronic>.freeze, ["~> 0.10.2"])
end
