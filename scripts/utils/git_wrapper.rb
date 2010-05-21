class GitWrapper
  def initialize(repo_path, repo_url)
    @repo = repo_path
    @url = repo_url
  end

  def get_authors
    ensure_repo_exists

    puts 'Getting authors from repo'
    Dir.chdir(File.expand_path(@repo)) do
      fetch
      return parse_rev_list
    end
  end

  private
  def ensure_repo_exists
    return if File.exists? @repo

    puts "Repo '#{@repo}' doesn\'t exist. Creating."
    puts `git clone #{@url} #{@repo}`
  end

  def fetch
    `git fetch`
  end

  def parse_rev_list
    `git rev-list origin/master --format=format:%an | grep -v ^commit | sort | uniq`.split(/\n/)
  end
end


