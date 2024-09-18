# frozen_string_literal: true

require_relative 'lib/sheets_v4/version'

Gem::Specification.new do |spec|
  spec.name = 'sheets_v4'
  spec.version = SheetsV4::VERSION
  spec.authors = ['James Couball']
  spec.email = ['jcouball@yahoo.com']

  spec.summary = 'Unofficial helpers and extensions for the Google Sheets V4 API'
  spec.description = spec.summary
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Project links
  spec.homepage = "https://github.com/main-branch/#{spec.name}"
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['documentation_uri'] = "https://rubydoc.info/gems/#{spec.name}/#{spec.version}"
  spec.metadata['changelog_uri'] = "https://rubydoc.info/gems/#{spec.name}/#{spec.version}/file/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.requirements = [
    'Platform: Mac, Linux, or Windows',
    'Ruby: MRI 3.1 or later, TruffleRuby 24 or later, or JRuby 9.4 or later'
  ]

  spec.add_development_dependency 'bundler-audit', '~> 0.9'
  spec.add_development_dependency 'create_github_release', '~> 1.5'
  spec.add_development_dependency 'discovery_v1', '~> 0.1'
  spec.add_development_dependency 'main_branch_shared_rubocop_config', '~> 0.1'
  spec.add_development_dependency 'rake', '~> 13.2'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'rubocop', '~> 1.66'
  spec.add_development_dependency 'simplecov', '~> 0.22'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8'
  spec.add_development_dependency 'simplecov-rspec', '~> 0.3'

  unless RUBY_PLATFORM == 'java'
    spec.add_development_dependency 'redcarpet', '~> 3.6'
    spec.add_development_dependency 'yard', '~> 0.9', '>= 0.9.28'
    spec.add_development_dependency 'yardstick', '~> 0.9'
  end

  spec.add_dependency 'activesupport', '~> 7.0'
  spec.add_development_dependency 'github_pages_rake_tasks', '~> 0.1'
  spec.add_dependency 'google-apis-sheets_v4', '~> 0.26'
  spec.add_dependency 'googleauth'
  spec.add_dependency 'json_schemer', '~> 2.0'
  spec.add_dependency 'rltk', '~> 3.0'
end
