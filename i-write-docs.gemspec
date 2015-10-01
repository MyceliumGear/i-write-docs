# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: i-write-docs 0.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "i-write-docs"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dmitry Tymchuk"]
  s.date = "2015-09-28"
  s.description = "Documentation based on Git repository with versions as tags and diff between that versions"
  s.email = "dsnipe@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "{app,config,lib}/**/*",
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "i-write-docs.gemspec"
  ]
  s.homepage = "http://github.com/dsnipe/i-write-docs"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Documentation based on Git repository"

  s.add_dependency(%q<rubytree>, [">= 0"])
  s.add_dependency(%q<redcarpet>, [">= 0"])
  s.add_dependency(%q<pygments.rb>, [">= 0"])
  s.add_dependency(%q<rugged>, [">= 0"])
  s.add_dependency(%q<minitest>, ["~> 5"])
  s.add_dependency(%q<bundler>, ["~> 1.0"])
  s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
  s.add_dependency(%q<simplecov>, [">= 0"])
  s.add_dependency(%q<haml-rails>, [">= 0"])
  s.add_dependency "sass-rails", [">= 3"]
end
