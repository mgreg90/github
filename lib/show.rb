require_relative './routes.rb'

module Github
  module CLI
    module Commands
      extend Playwright::CLI::Registry

      class Show < Playwright::CLI::Command
        argument :commit_hash, required: true, validations: [Proc.new { |sha| valid_commit? sha }]

        desc "Opens browser to show the commit."
        
        def self.git
          @git || begin
            current_dir = Dir.pwd
            while current_dir.length > Dir.home.length
              begin
                @git = Git.open(current_dir)
                return @git
              rescue ArgumentError => e
                current_dir = File.expand_path('..', current_dir)
              end
            end
          end
        end

        def self.valid_commit? commit
          all_commit_hashes.any? { |sha| commit_regex(commit) =~ sha }
        end

        def self.all_commit_hashes
          git.log(100_000).map &:sha
        end

        def self.commit_regex sha
          /^#{sha}/
        end

        def call(commit_hash:, **)
          @commit_hash = commit_hash.downcase
          os.open_url url: url
        end

        private

        def git
          @git ||= self.class.git
        end

        def user
          # regex turns "git@github.com:mgreg90/playwright-cli.git" into 'mgreg90'
          @user ||= git.remote.url.match(/:(?<name>.+)\//)[:name]
        end

        def repo
          # regex turns "git@github.com:mgreg90/playwright-cli.git" into 'playwright-cli'
          @repo ||= git.remote.url.match(/\/(?<name>.+)\./)[:name]
        end

        def url
          url = Routes::GITHUB_URL
          url.path = "/#{[ user, repo, 'commit', @commit_hash ].compact.join('/')}"
          url
        end

      end

    end
  end
end