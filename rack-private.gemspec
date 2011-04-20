# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rack/private/version'

Gem::Specification.new do |s|
  s.name        = "rack-private"
  s.version     = Rack::Private::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thibaud Guillaume-Gentil"]
  s.email       = ["thibaud@thibaud.me"]
  s.homepage    = "http://github.com/thibaudgg/rack-private"
  s.summary     = "Protect your Rack application from anonymous."
  s.description = "Private Rack middleware purpose is to protect your Rack application from anonymous via a secret code form."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rack-private"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "shoulda", "~> 2.11.3"
  s.add_development_dependency "rack", "~> 1.2.0"
  s.add_development_dependency "rack-test", "~> 0.5.4"

  s.files        = Dir.glob("{lib}/**/*") + %w[LICENSE README.markdown]
  s.require_path = 'lib'
end