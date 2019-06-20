# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pig_ci/version'

Gem::Specification.new do |spec|
  spec.name          = 'pig-ci'
  spec.version       = PigCi::VERSION
  spec.authors       = ['Mike Rogers']
  spec.email         = ['me@mikerogers.io']

  spec.summary       = 'Write a short summary, because RubyGems requires one.'
  spec.description   = 'Write a longer description or delete this line.'
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency 'activesupport', '>= 4.2'
  spec.add_dependency 'colorize', '>= 0.8.1'
  spec.add_dependency 'get_process_mem', '~> 0.2.2'
  spec.add_dependency 'httparty', '>= 0.16'
  spec.add_dependency 'i18n', '>= 1.0'
  spec.add_dependency 'terminal-table', '~> 1.8.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'webmock'

  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'launchy'
  spec.add_development_dependency 'rails', '~> 5.2'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'sqlite3', '~> 1.3.6'
end
