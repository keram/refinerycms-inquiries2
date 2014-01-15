# Encoding: UTF-8

require 'date'
require File.expand_path('../lib/refinery/inquiries/version', __FILE__)

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-inquiries2'
  s.version           = '0.0.1'
  s.description       = 'Ruby on Rails Inquiries forms-extension for Refinery CMS'
  s.date              = Date.today.strftime("%Y-%m-%d")
  s.summary           = 'Inquiries forms-extension for Refinery CMS'
  s.authors           = ['Marek Labos']
  s.email             = 'nospam.keram@gmail.com'
  s.homepage          = 'https://www.github.com/keram/refinerycms-inquiries2'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency    'refinerycms-core',     '~> 2.718.0.dev'
  s.add_dependency    'refinerycms-settings', '~> 2.718.0.dev'
  s.add_dependency    'filters_spam',         '~> 0.3'
end
