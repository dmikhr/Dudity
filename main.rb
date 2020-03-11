# examples of Dudity gem features
# uncomment code for testing selected feature
require 'dudity'

# Dudity.visualise('/Users/dmkp/Documents/code/ruby/dudes/dudeshub/dudeshub', except: ['app/controllers'])

# Dudity.visualise('/Users/dmkp/Documents/code/ruby/dudes/dudeshub/dudeshub', only: ['app/models', 'app/controllers'])
# Dudity.visualise('/Users/dmkp/Documents/code/ruby/dudes/dudeshub/dudeshub') # scan all
#
# Dudity.visualise('/Users/dmkp/Documents/code/ruby/dudes/dudeshub/dudeshub', only: ['app/models'], ignore_classes: ['Ability', 'User'], filename_suffix: '_test')
# Dudity.visualise('/Users/dmkp/Documents/code/ruby/dudes/dudeshub/dudeshub', only: ['app/models'], only_classes: ['Ability', 'User'])
#
# Dudity.visualise_diff('/Users/dmkp/Documents/code/ruby/dudes/dudity_test/test_repo_dude/pull_7.diff', pull_branch: 'task4', as: :html)

Dudity.visualise_pr('https://github.com/dmikhr/test_repo_dude/pull/7', pull_branch: 'task4', as: :html)
# Dudity.visualise_pr('https://github.com/dmikhr/test_repo_dude/pull/7', pull_branch: 'task4', as: :svg)

# use gem features to present dudes divided by categories
# path = '/Users/dmkp/Documents/code/ruby/dudes/dudeshub/dudeshub'
# app_name = 'dudeshub'
#
# Dudity.visualise(path, only: ['app/models'], filename_suffix: '_models')
# Dudity.visualise(path, only: ['app/controllers'], filename_suffix: '_controllers')
# Dudity.visualise(path, except: ['app/models', 'app/controllers'], filename_suffix: '_other')
#
# html = open('templates/dudes_report_visualise.html').read
# html = html.sub('[controllers_filename]', "#{app_name}_controllers")
# html = html.sub('[models_filename]', "#{app_name}_models")
# html = html.sub('[other_filename]', "#{app_name}_other")
#
# File.open('dudes_report_visualise.html', 'w') { |file| file.write(html) }
