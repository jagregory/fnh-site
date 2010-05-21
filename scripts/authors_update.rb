require 'scripts/utils/git_wrapper'

class AuthorsUpdater
  def execute
    authors = get_authors
    authors[-1] = "and #{authors.last}." # sentencize it
    formatted_authors = authors.join(', ')

    File.open(File.expand_path('_includes/authors.md'), 'w').puts formatted_authors
  end

  private
  def get_authors
    git = GitWrapper.new 'repo', 'git://github.com/jagregory/fluent-nhibernate.git'
    authors = git.get_authors
    
    puts "Found #{authors.length} authors"
    # remove invalid or duplicate users
    authors.delete "="
    authors.delete "(no author)"
    authors.delete "HudsonAkridge"
    authors.delete "childss"
    authors.delete "JSkinner"
    authors.delete "Musgrove@.(none)"
    authors.delete "unknown"
    authors
  end
end
