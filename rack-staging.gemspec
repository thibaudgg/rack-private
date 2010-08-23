# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rack-staging/version'

Gem::Specification.new do |s|
  s.name        = "rack-staging"
  s.version     = Rack::Staging::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Aleksandr Koss"]
  s.email       = ["kossnocorp@gmail.com"]
  s.homepage    = "http://github.com/kossnocorp/staging"
  s.summary     = "Protect you Rails application from anonymous and prying."
  s.description = "Staging rack application purpose to protect you Rails application from anonymous and prying."
  
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rack-staging"
  
  s.add_development_dependency "bundler", ">= 1.0.0.rc.5"
  
  s.files        = Dir.glob("{lib}/**/*") + %w[README.textile]
  s.require_path = 'lib'
end