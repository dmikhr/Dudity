require 'dudegl'
require 'open-uri'

Dir[File.dirname(__FILE__) + '/**/*.rb'].each {|file| require_relative file }

class Dudity
  class << self
    def visualise(path, opt = {})
      @path = path
      opt.key?(:except) ? except = opt[:except] : except = nil
      opt.key?(:only) ? only = opt[:only] : only = nil
      opt.key?(:ignore_classes) ? ignore_classes = opt[:ignore_classes] : ignore_classes = nil
      opt.key?(:only_classes) ? only_classes = opt[:only_classes] : only_classes = nil
      opt.key?(:filename_suffix) ? filename_suffix = opt[:filename_suffix] : filename_suffix = ''

      project_files = ScanApp.call(@path, except, only)
      app_name = @path.split('/').last

      @params_list = []
      project_files.each { |project_file| process_item(project_file) }

      @params_list = @params_list.flatten.compact
      exclude_classes(ignore_classes) if ignore_classes
      include_classes(only_classes) if only_classes

      dudes = DudeGl.new @params_list, dudes_per_row_max: 4
      dudes.render
      dudes.save "#{app_name}#{filename_suffix}"
    end

    def visualise_diff(path_to_diff, opt = {})
      @params1 = []
      @params2 = []

      # path to the dir where diff file is stored
      @path = path_to_diff.split('/').take(path_to_diff.split('/').size - 1).join('/')

      opt.key?(:as) ? file_type = opt[:as] : file_type = :svg
      opt.key?(:pull_branch) ? @pull_branch = opt[:pull_branch] : return

      diff = open(path_to_diff).readlines
      @diff_data = GitDiffService.call(diff)

      return generate_svg if file_type == :svg
      return generate_html_report if file_type == :html
    end

    def visualise_pr(public_pr_link, opt = {})
      @params1 = []
      @params2 = []

      @path = public_pr_link
      diff_url = "#{public_pr_link}.diff"

      opt.key?(:as) ? file_type = opt[:as] : file_type = :svg
      opt.key?(:pull_branch) ? @pull_branch = opt[:pull_branch] : return

      diff = DownloadService.call(diff_url, :read_by_line)
      @diff_data = GitDiffService.call(diff)

      return generate_svg if file_type == :svg
      return generate_html_report if file_type == :html
    end

    private

    # generate name based on pull request data. Example: DudesHub_pull_5
    def fname
      @path.split('/')[-3, 3].join('_')
    end

    # generate html report title based on repo data, make each word capitalized
    def report_title
      @path.split('/')[-3, 3].map(&:capitalize).join(' ')
    end

    def generate_svg
      analyze_code(@diff_data)
    end

    def generate_html_report
      separate_code
      analyze_by_category

      html = open('templates/dudes_report.html').read
      html = html.sub('[dudes_report_title]', report_title)
      @report_file_path = "#{fname}.html"
      File.open(@report_file_path, 'w') { |file| file.write(html) }
    end

    def separate_code
      @diff_data_controllers = []
      @diff_data_models = []
      @diff_data_others = []

      @diff_data.each do |item|
        if item[:old_name]&.start_with?("app/controllers") || item[:new_name]&.start_with?("app/controllers")
          @diff_data_controllers << item
        elsif item[:old_name]&.start_with?("app/models") || item[:new_name]&.start_with?("app/models")
          @diff_data_models << item
        else
          @diff_data_others << item
        end
      end
    end

    def analyze_by_category
      analyze_code(@diff_data_controllers, :controllers) if !@diff_data_controllers.empty?
      analyze_code(@diff_data_models, :models) if !@diff_data_models.empty?
      analyze_code(@diff_data_others, :others) if !@diff_data_others.empty?
    end

    def analyze_code(diff_data, label = nil)
      @params1 = []
      @params2 = []
      local = !@path.start_with?('http')
      local ? suffix = '_local' : suffix = ''

      diff_data.map { |item| process_item_for_diff(item, local) }

      renamed = diff_data.select { |item| item[:status] == :renamed_class }

      return false if params_empty?

      dudes = DudeGl.new [@params1.flatten.compact, @params2.flatten.compact],
                          dudes_per_row_max: 4, renamed: renamed, diff: true
      dudes.render

      label ? dudes.save("#{label}#{suffix}") : dudes.save("#{fname}#{suffix}")
    end

    def process_item(project_file)
      code = open(project_file).read
      @params_list << Dudes::Calculator.new(code).call
    end

    def process_item_for_diff(item, local = false)
      processed_code = ProcessCodeService.new(@path, @pull_branch, item, local = local).call
      @params1 << processed_code.first
      @params2 << processed_code.last
    end

    def params_empty?
      @params1.empty? || @params2.empty?
    end

    def exclude_classes(classes)
      @params_list = @params_list.reject { |param| classes.any? { |item| param[:name] == item } }
    end

    def include_classes(classes)
      @params_list = @params_list.select { |param| classes.any? { |item| param[:name] == item } }
    end
  end
end
