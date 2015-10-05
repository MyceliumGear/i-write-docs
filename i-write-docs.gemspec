# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: i-write-docs 0.0.0 ruby lib

$:.push File.expand_path("../lib", __FILE__)

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

  s.add_dependency "rubytree", [">= 0"]
  s.add_dependency "redcarpet", [">= 0"]
  s.add_dependency "pygments.rb", [">= 0"]
  s.add_dependency "rugged", [">= 0"]
  s.add_dependency "minitest", ["~> 5"]
  s.add_dependency "bundler", ["~> 1.0"]
  s.add_dependency "simplecov", [">= 0"]
  s.add_dependency "haml-rails", [">= 0"]
  s.add_dependency "sass-rails", [">= 3"]
  s.add_dependency "rails", [">= 4"]
end

