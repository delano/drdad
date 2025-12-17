# frozen_string_literal: true

require_relative 'lib/drdad/version'

Gem::Specification.new do |spec|
  spec.name          = 'drdad'
  spec.version       = DrDad::VERSION
  spec.authors       = ['Delano Mandelbaum']
  spec.email         = ['delano@onetimesecret.com']

  spec.summary       = 'Daily Report of Developer Activity Data'
  spec.description   = 'Git productivity tracking with AI-powered summaries using Claude Haiku. Track daily commits, lines changed, and file modifications with AI-generated summaries of each day\'s work. Supports daily, weekly, and monthly aggregation with commit type classification and issue reference extraction.'
  spec.homepage      = 'https://github.com/delano/drdad'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/delano/drdad'
  spec.metadata['changelog_uri'] = 'https://github.com/delano/drdad/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = ['drdad']
  spec.require_paths = ['lib']

  # No runtime dependencies - uses only Ruby stdlib:
  # - json, date, time, optparse, fileutils, open3, set
  # - net/http, uri (for Anthropic API)
end
