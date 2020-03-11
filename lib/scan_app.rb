class ScanApp
  class << self
    EXCLUDE_FOLDERS = ['db/', 'spec/', 'config/']
    ALLOWED_EXTENSIONS = ['.rb']

    def call(path, except, only)
      @except = except
      @only = only
      # list of all files from app dir recursively
      @project_files = Dir.glob("#{path}/**/*")

      filter_by_extension
      exclude_default

      exclude_files if @except
      include_only_files if @only
      @project_files
    end

    private

    def exclude_default
      @project_files = @project_files.reject { |project_file| match?(project_file, EXCLUDE_FOLDERS) }
    end

    def filter_by_extension
      @project_files = @project_files.select { |project_file| project_file.end_with?(*ALLOWED_EXTENSIONS) }
    end

    def exclude_files
      @project_files = @project_files.reject { |project_file| match?(project_file, @except) }
    end

    def include_only_files
      @project_files = @project_files.select { |project_file| match?(project_file, @only) }
    end

    def match?(string, matches)
      matches.any? { |item| string.include?(item) }
    end
  end
end
