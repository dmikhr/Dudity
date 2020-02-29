require_relative 'lib/dudity.rb'

Dudity.visualise('/Users/dmkp/Documents/code/ruby/dudes/dudeshub/dudeshub', except: ['app/controllers'])
#
# Dudity.visualise('./projects/my_app', only: ['app/models'])
#
# Dudity.visualise('./projects/my_app', only: ['app/models'], ignore_classes: ['SomeClass'])
#
# Dudity.visualise_diff('https://patch-diff.githubusercontent.com/raw/dmikhr/test_repo_dude/pull/4.diff')
#
# Dudity.visualise_pr(public_pr_link, as: :png)
# Dudity.visualise_pr(public_pr_link, as: :svg)
# Dudity.visualise_pr(public_pr_link, as: :html)
