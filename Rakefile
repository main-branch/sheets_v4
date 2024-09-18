# frozen_string_literal: true

desc 'Run the same tasks that the CI build will run'
if RUBY_PLATFORM == 'java'
  task default: %w[spec rubocop bundle:audit build]
else
  task default: %w[spec rubocop yard bundle:audit build]
end

# Bundler Audit

require 'bundler/audit/task'
Bundler::Audit::Task.new

# Bundler Gem Build

require 'bundler'
require 'bundler/gem_tasks'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

CLEAN << 'pkg'
CLEAN << 'Gemfile.lock'

# RSpec

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do
  if RUBY_PLATFORM == 'java'
    ENV['JAVA_OPTS'] = '-Djdk.io.File.enableADS=true'
    ENV['JRUBY_OPTS'] = '--debug'
    ENV['NOCOV'] = 'TRUE'
  end
end

CLEAN << 'coverage'
CLEAN << '.rspec_status'
CLEAN << 'rspec-report.xml'

# Rubocop

require 'rubocop/rake_task'

RuboCop::RakeTask.new

# YARD

unless RUBY_PLATFORM == 'java'
  # yard:build

  require 'yard'

  YARD::Rake::YardocTask.new('yard:build') do |t|
    t.files = %w[lib/**/*.rb]
    t.stats_options = ['--list-undoc']
  end

  CLEAN << '.yardoc'
  CLEAN << 'doc'

  # yard:audit

  desc 'Run yardstick to show missing YARD doc elements'
  task :'yard:audit' do
    sh "yardstick 'lib/**/*.rb'"
  end

  # yard:coverage

  require 'yardstick/rake/verify'

  Yardstick::Rake::Verify.new(:'yard:coverage') do |verify|
    verify.threshold = 100
    verify.require_exact_threshold = false
  end

  task yard: %i[yard:build yard:audit yard:coverage]

  # github-pages:publish

  require 'github_pages_rake_tasks'
  GithubPagesRakeTasks::PublishTask.new do |task|
    # task.doc_dir = 'documentation'
    task.verbose = true
  end
end
