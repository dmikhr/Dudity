# use source code of gems to simplify their code editing (if improvements are needed or bugs are found)
# in the final version of app gems will be used
require '/Users/dmkp/Documents/code/ruby/dudes/dudegl_repo/lib/dudegl.rb'
require '/Users/dmkp/Documents/code/ruby/dudes/zverok_dudes_fork2/dudes/lib/dudes.rb'
require 'open-uri'
require 'byebug'

Dir[File.dirname(__FILE__) + '/**/*.rb'].each {|file| require_relative file }

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

      dudes = DudeGl.new @params_list.flatten.compact, dudes_per_row_max: 4
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
      @public_pr_link = public_pr_link
      diff_url = "#{public_pr_link}.diff"
      opt.key?(:as) ? file_type = opt[:as] : file_type = :svg
      opt.key?(:pull_branch) ? @pull_branch = opt[:pull_branch] : return

      @params1 = []
      @params2 = []

      diff = DownloadService.call(diff_url, :read_by_line)
      @diff_data = GitDiffService.call(diff)
      @diff_data.map { |item| process_item_for_diff(item) }

      renamed = @diff_data.select { |item| item[:status] == :renamed_class }

      return false if params_empty?

      dudes = DudeGl.new [@params1.flatten.compact, @params2.flatten.compact],
                          dudes_per_row_max: 4, renamed: renamed, diff: true
      dudes.render
      dudes.save fname
    end

    private

    # generate name based on pull request data. Example: DudesHub_pull_5
    def fname
      @public_pr_link.split('/')[-3, 3].join('_')
    end

    def process_item(project_file)
      code = open(project_file).read
      @params_list << Dudes::Calculator.new(code).call
    end

    def process_item_for_diff(item)
      processed_code = ProcessCodeService.new(@public_pr_link, @pull_branch, item).call
      @params1 << processed_code.first
      @params2 << processed_code.last
    end

    def params_empty?
      @params1.empty? || @params2.empty?
    end
  end
end
