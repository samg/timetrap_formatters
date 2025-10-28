# -*- encoding: utf-8 -*-
# stub: timetrap-harvest 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "timetrap-harvest".freeze
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Devon Blandin".freeze]
  s.date = "2014-06-12"
  s.description = "    timetrap-harvest bridges the gap between your entries in Timetrap and your\n    project tasks in Harvest allowing for incredible easy timesheet\n    submissions.\n".freeze
  s.email = "dblandin@gmail.com".freeze
  s.homepage = "https://github.com/dblandin/timetrap-harvest".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "A Harvest formatter for Timetrap".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<timetrap>.freeze, ["~> 1.7", ">= 1.7.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0", ">= 3.0.0"])
  s.add_development_dependency(%q<pry>.freeze, ["~> 0.10", ">= 0.10.0"])
end
