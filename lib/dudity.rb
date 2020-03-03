# use source code of gems to simplify their code editing (if improvements are needed or bugs are found)
# in the final version of app gems will be used
require '/Users/dmkp/Documents/code/ruby/dudes/dudegl_repo/lib/dudegl.rb'
require '/Users/dmkp/Documents/code/ruby/dudes/zverok_dudes_fork2/dudes/lib/dudes.rb'
require_relative 'git_diff_service'
require_relative 'scan_app'
require 'open-uri'
require 'byebug'


class Dudity
  class << self
    def visualise(path, opt = {})
      @path = path
      opt.key?(:except) ? except = opt[:except] : except = nil
      opt.key?(:only) ? only = opt[:only] : only = nil

      project_files = ScanApp.call(@path, except, only)
      app_name = @path.split('/').last

      @params_list = []
      project_files.each { |project_file| process_item(project_file) }

      dudes = DudeGl.new @params_list, dudes_per_row_max: 4
      dudes.render
      dudes.save app_name
    end

    def visualise_diff(path_to_diff, opt = {})
      # TO-DO: read local diff file
      diff_lines = open(path_to_diff).readlines
      diff_data = GitDiffService.call(diff_lines)
      pp diff_data
    end

    def visualise_pr(public_pr_link, opt = {})
      # can we implement this without access to Github API? (DudesHub can do it only using API)
      @params1 = []
      @params2 = []

      diff_url = "#{public_pr_link}.diff".readlines
      # generate name based on pull request data. Example: DudesHub_pull_5
      fname = public_pr_link.split('/')[-3, 3].join('_')

      diff_data = GitDiffService.call(diff_lines)
      diff_data.map { |item| process_item(item) }

      dudes = DudeGl.new [@params1.flatten.compact, @params2.flatten.compact],
                          dudes_per_row_max: 4, renamed: renamed, diff: true
      dudes.render
      dudes.save fname
    end

    private

    def process_item(project_file)
      code = open(project_file).read
      @params_list << Dudes::Calculator.new(code).call
    end
  end
end
