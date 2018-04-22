require_relative './routes.rb'

module Github
  module CLI
    module Commands
      extend Playwright::CLI::Registry

      class New < Playwright::CLI::Command
        desc "Opens browser to new repo screen."

        example ["# Opens browser to new repo screen."]

        def call(**)
          new_repo_url = "#{Routes::GITHUB_URL}/new"
          os.open_url url: new_repo_url
        end

      end

    end
  end
end