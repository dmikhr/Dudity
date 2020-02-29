# use source code of gems to simplify their code editing (if improvements are needed or bugs are found)
# in the final version of app gems will be used
require '/Users/dmkp/Documents/code/ruby/dudes/dudegl_repo/lib/dudegl.rb'
require_relative 'git_diff_service'
require 'open-uri'

class Dudity
  ALLOWED_EXTENSIONS = ['.rb']

  class << self
    def visualise(path, opt = {})
      @path = path
      opt.key?(:except) ? @except = opt[:except] : @except = nil
      opt.key?(:only) ? @only = opt[:only] : @only = nil

      @project_files = Dir.glob("#{@path}/**/*")
      exclude_files if @except
      include_only_files if @only
    end

    def visualise_diff(path_to_diff, opt = {})
      # TO-DO: read local diff file
      diff_lines = open(path_to_diff).readlines
      diff_data = GitDiffService.call(diff_lines)
      pp diff_data
    end

    def visualise_pr(public_pr_link, opt = {})
      diff_url = "#{public_pr_link}.diff"
    end

    private

    def exclude_files
      @project_files = @project_files.reject { |project_file| project_file.include?(*@except) }
    end

    def include_only_files
      @project_files = @project_files.select { |project_file| project_file.include?(*@only) }
    end

    def filter_by_extension
      @project_files = @project_files.select { |project_file| project_file.end_with?(*ALLOWED_EXTENSIONS) }
    end
  end
end
