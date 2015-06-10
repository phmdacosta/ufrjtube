# -*- encoding: utf-8 -*-

require 'carrierwave/version'
require 'date'

Gem::Specification.new do |s|
  s.name = "ufrjtube"
  s.version = 1.0

  s.authors = ["Pedro Costa"]
  s.date = Date.today
  s.description = "A video streamming plataform"
  s.summary = ""
  s.email = ["ph.mcosta@hotmail.com"]
  s.rdoc_options = ["--main"]
  s.rubyforge_project = %q{carrierwave}
  s.rubygems_version = %q{1.3.5}
  s.specification_version = 3
  s.licenses = ["MIT"]

  s.add_dependency "activesupport", ">= 3.2.0"
  s.add_dependency "activemodel", ">= 3.2.0"
  s.add_dependency "json", ">= 1.7"
  s.add_development_dependency "rspec", "~> 3.2.0"
  s.add_development_dependency "sinatra"
  s.add_development_dependency "sinatra-contrib"
  s.add_development_dependency "fog", ">= 1.28.0"
  s.add_development_dependency "generator_spec"
end