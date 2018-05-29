require_relative './routes.rb'

module Github
  module CLI
    module Commands
      extend Playwright::CLI::Registry

      class Open < Playwright::CLI::Command
        desc "Opens browser to github."

        example ["# Opens browser to github."]

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

        def self.valid_path?(path)
          path_arr = path.split(':')
          path = path_arr.length <= 2 ? path_arr.first : path[0..-2].join(':')
          File.exists? path
        end

        option :branch, default: nil, values: self.branch_names, desc: "branch name"
        option :path, default: nil, desc: "file path", aliases: ['--file'], validations: [Proc.new { |path| valid_path? path } ]
        option :blame, type: :boolean, default: false, desc: "go to git blame page", aliases: ['-b']

        def call(branch: nil, path: nil, blame: nil, **args)
          display.error "Not a git repository!" unless git
          display.error "Cannot git blame without a file!\n(Use -f option to pass a file)" if blame && path.nil?
          display.error "Cannot git blame a directory!" if blame && File.directory?(path)
          @branch = branch
          @raw_path = path
          @blame = blame
          os.open_url url: url
        end

        private

        def url
          url = Routes::GITHUB_URL
          type = @blame ? 'blame' : 'tree'
          url.path = "/#{[ user, repo, type, branch, path ].compact.join('/')}"
          url + anchor
        end

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

        def branch
          @branch ||= git.branch.name
        end

        def raw_path
          @raw_path ||= (/#{git.dir}\/(?<path>.*)/i.match(Dir.pwd) || {})[:path] || ''
        end

        def path_arr
          (raw_path || '').split(':')
        end

        def path
          path_arr.length <= 2 ? path_arr.first : path[0..-2].join(':')
        end

        def anchor
          @anchor ||= begin
            path_arr.length > 1 ? "#L#{path_arr.last}" : ''
          end
        end

      end

    end
  end
end