# github

github is a [playwright-cli](https://github.com/mgreg90/playwright-cli) script.
It let's you easily launch the github website in your browser to your current
project. Options let you open up a git blame on a certain file or begin to
create a pull request.

## Installation

This script relies on the playwright-cli gem. Sharing features are still
in development for playwright, so for now, you'll need to run the following
commands to install it.

```shell
$ gem install playwright-cli
$ mkdir -p "$HOME/.playwright/plays"
$ cd "$HOME/.playwright/plays" && git clone git@github.com:[GIT_USERNAME]/github.git
$ ln -s "$HOME/.playwright/plays/github/github.rb" "/usr/local/bin/github"
```

In the future, expect a `$ playwright get github` command to exist.

## Usage

Github has five subcommands: `new`, `open`, `pull-request`, `show`, and `version`

### Version

Just returns the version.
```shell
$ github version
#=> 0.0.2
```

### New

Opens github to the new repo screen
```shell
$ github new
```

### Open

Opens github to the current repo
```shell
$ github open
```

#### Options

-f, --file, --path
Open github to a particular file
```shell
$ github open -f app/your/file
```

-b, --blame
Open github to a particular file's git blame page.
Requires the -f option be passed as well.
```shell
$ github open -f app/your/file --blame
```

--branch
Open github to the given branch
```shell
$ github open --branch develop
```

### Pull Request

Opens github to the new pull request page.
Requires one argument - the branch you are creating your PR against.

```shell
$ github pr develop
```
OR
```shell
$ github pull-request master
```

### Show

Opens github to show the commit provided.
Works with partial commit hashes.

```shell
$ github show a3c71841d3c0ee28754512f3d19f0990b9647f22
```


## Thanks!

Thanks for checking out my script. If you're interested in ruby scripting,
consider creating a [playwright-cli](https://github.com/mgreg90/playwright-cli) script of your own!