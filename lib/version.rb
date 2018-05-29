module Github
  module CLI

    VERSION = "0.0.2"

    module Commands
      extend Playwright::CLI::Registry

      class Version < Playwright::CLI::Command
        desc "Responds with the version number."

        example ["#=> #{VERSION}"]

        def call(**)
          display.print VERSION
        end

      end

    end
  end
end