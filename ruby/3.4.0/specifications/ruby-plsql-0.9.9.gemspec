# -*- encoding: utf-8 -*-
# stub: ruby-plsql 0.9.9 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-plsql".freeze
  s.version = "0.9.9".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Raimonds Simanovskis".freeze]
  s.date = "1980-01-02"
  s.description = "ruby-plsql gem provides simple Ruby API for calling Oracle PL/SQL procedures.\nIt could be used both for accessing Oracle PL/SQL API procedures in legacy applications\nas well as it could be used to create PL/SQL unit tests using Ruby testing libraries.".freeze
  s.email = "raimonds.simanovskis@gmail.com".freeze
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze]
  s.homepage = "https://github.com/rsim/ruby-plsql".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "4.0.10".freeze
  s.summary = "Ruby API for calling Oracle PL/SQL procedures.".freeze

  s.installed_by_version = "3.6.9".freeze

  s.specification_version = 4

  s.add_development_dependency(%q<rake>.freeze, [">= 10.0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1".freeze])
  s.add_development_dependency(%q<rspec_junit_formatter>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<ruby-oci8>.freeze, ["~> 2.1".freeze])
end
