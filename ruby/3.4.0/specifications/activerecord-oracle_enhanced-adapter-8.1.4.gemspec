# -*- encoding: utf-8 -*-
# stub: activerecord-oracle_enhanced-adapter 8.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "activerecord-oracle_enhanced-adapter".freeze
  s.version = "8.1.4".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 1.8.11".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Raimonds Simanovskis".freeze]
  s.date = "1980-01-02"
  s.description = "Oracle \"enhanced\" ActiveRecord adapter contains useful additional methods for working with new and legacy Oracle databases.\nThis adapter is superset of original ActiveRecord Oracle adapter.\n".freeze
  s.email = "raimonds.simanovskis@gmail.com".freeze
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze]
  s.homepage = "http://github.com/rsim/oracle-enhanced".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.2.0".freeze)
  s.rubygems_version = "4.0.11".freeze
  s.summary = "Oracle enhanced adapter for ActiveRecord".freeze

  s.installed_by_version = "3.6.9".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<activerecord>.freeze, ["~> 8.1.0".freeze])
  s.add_runtime_dependency(%q<ruby-plsql>.freeze, [">= 0.6.0".freeze])
  s.add_runtime_dependency(%q<ruby-oci8>.freeze, [">= 0".freeze])
end
