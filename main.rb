require_relative 'lib/dudity.rb'

# Dudity.visualise('/Users/dmkp/Documents/code/ruby/dudes/dudeshub/dudeshub', except: ['app/controllers'])

# Dudity.visualise('/Users/dmkp/Documents/code/ruby/dudes/dudeshub/dudeshub', only: ['app/models'])
# Dudity.visualise('/Users/dmkp/Documents/code/ruby/dudes/dudeshub/dudeshub') # scan all
#
# Dudity.visualise('./projects/my_app', only: ['app/models'], ignore_classes: ['SomeClass'])
#
# Dudity.visualise_diff('https://patch-diff.githubusercontent.com/raw/dmikhr/test_repo_dude/pull/4.diff')
#
# Dudity.visualise_pr(public_pr_link, as: :png)
Dudity.visualise_pr('https://github.com/dmikhr/test_repo_dude/pull/7', pull_branch: 'task4', as: :html)
Dudity.visualise_pr('https://github.com/dmikhr/test_repo_dude/pull/7', pull_branch: 'task4', as: :svg)
# Dudity.visualise_pr(public_pr_link, as: :html)
