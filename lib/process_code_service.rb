# use source code of gems to simplify their code editing (if improvements are needed or bugs are found)
# in the final version of app gems will be used
require '/Users/dmkp/Documents/code/ruby/dudes/zverok_dudes_fork2/dudes/lib/dudes.rb'

class ProcessCodeService
  def initialize(public_pr_link, pull_branch, file_data, local = false)
    @public_pr_link = public_pr_link
    @pull_branch = pull_branch
    @file_data = file_data
  end

  def call
    process_code_file

    [@params1, @params2]
  end

  private

  def process_code_file
    download_master_code
    download_pull_request_code
  end

  def download_master_code
    return unless [:deleted, :changed, :renamed].include?(@file_data[:status])
    code_master = DownloadService.call(code_master_branch_path)
    code_hash = Dudes::Calculator.new(code_master).call
    @params1 = code_hash.first unless code_hash.empty?
  end

  def download_pull_request_code
    return unless [:new, :changed, :renamed].include?(@file_data[:status])
    code_pull_request = DownloadService.call(code_pull_request_branch_path)
    code_hash = Dudes::Calculator.new(code_pull_request).call
    @params2 = code_hash.first unless code_hash.empty?
  end

  def get_code
    return open().read if local
    return DownloadService.call(code_master_branch_path)
  end

  def code_master_branch_path
    code_path = extract_code_path(:master)
    "https://raw.githubusercontent.com/#{repo_full_name}/master/#{code_path}"
  end

  def code_pull_request_branch_path
    code_path = extract_code_path(:pull)
    "https://raw.githubusercontent.com/#{repo_full_name}/#{@pull_branch}/#{code_path}"
  end

  def repo_full_name
    @public_pr_link.split('/')[-4, 2].join('/')
  end

  def extract_code_path(branch)
    return @file_data[:old_name] if deleted?
    return @file_data[:new_name] if new? || changed?
    return renamed?(branch)
  end

  def deleted?
    @file_data[:status] == :deleted
  end

  def new?
    @file_data[:status] == :new
  end

  def changed?
    @file_data[:status] == :changed
  end

  def renamed?(branch)
    return @file_data[:old_name] if branch == :master
    return @file_data[:new_name] if branch == :pull
  end
end
