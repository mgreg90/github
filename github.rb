#!/usr/bin/env ruby

require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'playwright-cli', require: 'playwright/cli'
  gem 'git', '~> 1.3'
  gem 'pry'
end

require 'uri'

require_relative 'lib/new'
require_relative 'lib/open'
require_relative 'lib/pull_request'
require_relative 'lib/show'
require_relative 'lib/version'

module Github
  module CLI
    module Commands
      extend Playwright::CLI::Registry

      register 'new', New # opens github to the new repo screen (option for gists)
      register 'open', Open # opens github to the current branch and file
      # options like --branch=somthing and --file=path/to/file.rb:30
      register 'pull-request', PullRequest, aliases: ['pr'] # opens the compare screen, optional
      # # extra arg opens pr against that branch
      register 'show', Show # opens github to the given commit
      register 'version', Version, aliases: ['v', '-v', '--version']

    end
  end
end

Playwright::CLI.new(Github::CLI::Commands).call