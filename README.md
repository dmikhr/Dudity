# Dudity

Dudity gem allows to test [DudeGL](https://github.com/dmikhr/DudeGL) features from your local machine.

See examples in `main.rb`

Gem supports 3 methods: `visualise`, `visualise_diff`, `visualise_pr`


**visualise**

Visualise code in a form of dudes

All code:
`Dudity.visualise('./projects/my_app')`

Only from selected folders:
`Dudity.visualise('./projects/my_app', only: ['app/models', 'app/controllers'])`

All code except some folders:
`Dudity.visualise('./projects/my_app', except: ['app/models', 'app/controllers'])`

Result will be saved in image folder in `svg` format.


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
