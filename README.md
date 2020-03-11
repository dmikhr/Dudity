# Dudity

Dudity gem allows to test [DudeGL](https://github.com/dmikhr/DudeGL) features from your local machine.

See examples in `main.rb`

Gem supports 3 methods: `visualise`, `visualise_diff`, `visualise_pr`

**Installation**

For installation run:

`gem install dudity`

or add gem to `Gemfile`:

`gem 'dudity'`

**visualise**

Visualise code in a form of dudes

All code:
`Dudity.visualise('./projects/my_app')`

Only from selected folders:
`Dudity.visualise('./projects/my_app', only: ['app/models', 'app/controllers'])`

All code except some folders:
`Dudity.visualise('./projects/my_app', except: ['app/models', 'app/controllers'])`

Result will be saved in image folder in `svg` format.

You can also specify particular classes that you want to exclude from analysis
`Dudity.visualise('./projects/my_app', only: ['app/models'], ignore_classes: ['Ability', 'User'])`

or analyze only selected classes:
`Dudity.visualise('./projects/my_app', only: ['app/models'], only_classes: ['Ability', 'User'])`

**visualise_diff**

Useful for analyzing your private repositories.
In order to use this feature:
* put code of your master branch and from a branch from which you are making pull request in the same folder on your local machine.
* from pull request page download `diff` file and put it in the same folder. To download `diff` file just add `.diff` to the end of pull request url. For example https://github.com/user/repo/pull/1 diff can be accessed by url: https://github.com/dmikhr/Dudity/pull/1.diff

Visualise diff and generate html report:
`Dudity.visualise_diff('./projects/my_app', pull_branch: 'pr_branch', as: :html)`

or just render an image:

`Dudity.visualise_diff('./projects/my_app', pull_branch: 'pr_branch', as: :svg)`

**visualise_pr**

Similar to `visualise_diff` but can be used for public pull requests. Instead of using local code it will fetch all necessary data from github.

`Dudity.visualise_pr('./projects/my_app', pull_branch: 'pr_branch', as: :html)`

or

`Dudity.visualise_pr('./projects/my_app', pull_branch: 'pr_branch', as: :svg)`

**Credits**

* Code parser (`lib/dudes.rb`) was created by Victor Shepelev ([zverok](https://github.com/zverok))
* The idea of code visualization with stick dudes was [presented](https://www.youtube.com/watch?v=MWGfwgL-934) by [Ivan Nemytchenko](https://github.com/inem) on RubyRussia 2019 conference
