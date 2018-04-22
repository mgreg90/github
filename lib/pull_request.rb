require_relative './routes.rb'

module Github
  module CLI
    module Commands
      extend Playwright::CLI::Registry

      class PullRequest < Playwright::CLI::Command
        desc "Opens browser to pull request screen."

        example ["# Opens browser to pull request screen."]
        
        
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

        def self.branch_names
          (git && git.branches || []).map(&:name)
        end
        
        argument :branch, required: true, validations: [Proc.new { |branch| branch_names.include? branch }]

        def call(branch:, **)
          @base_branch = branch
          os.open_url url: url
        end
        
        def git
          @git ||= self.class.git
        end

        def url
          url = Routes::GITHUB_URL
          type = 'compare'
          branches = "#{@base_branch}...#{head_branch}"
          url.path = "/#{[user, repo, type, branches].compact.join('/')}"
          url.query = "expand=1"
          url
        end

        def user
          # regex turns "git@github.com:mgreg90/playwright-cli.git" into 'mgreg90'
          @user ||= git.remote.url.match(/:(?<name>.+)\//)[:name]
        end

        def repo
          # regex turns "git@github.com:mgreg90/playwright-cli.git" into 'playwright-cli'
          @repo ||= git.remote.url.match(/\/(?<name>.+)\./)[:name]
        end

        def head_branch
          git.lib.branch_current
        end

      end

    end
  end
end