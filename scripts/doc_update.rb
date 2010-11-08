require 'scripts/utils/read_http.rb'
require 'scripts/utils/hasher.rb'
require 'rubygems'
require 'zip/zip'

API_DIR = 'api'
DOC_HASH_FILE = 'doc_csv.hash'

class DocsUpdater
  def initialize(downloads_dir)
    @downloads_dir = downloads_dir
  end
  
  def execute
    if has_update?
      puts 'Getting docs zip'
      download_file('fluentnhibernate-docs-{build.number}.zip')
      save_hash
    else
      puts 'No updates available'
    end
  end

  private
  def has_update?
    @hash = Hash.generate get_latest_filename

    Hash.changed? @hash, DOC_HASH_FILE
  end
  
  def save_hash
    Hash.save @hash, DOC_HASH_FILE
  end
  
  def get_latest_filename
    path = get_actual_path('fluentnhibernate-docs-{build.number}.zip')
    /[^\/]{1,}\.zip$/.match(path)[0]
  end

  def get_actual_path(filename)
    headers = HttpPage.read_headers('teamcity.codebetter.com', "/guestAuth/repository/download/bt9/.lastSuccessful/#{filename}")
    /(.*);/.match(headers['location'])[1]
  end

  def download_file(filename)
    download_uri = URI.parse(get_actual_path(filename))  
    download_name = /[^\/]{1,}\.zip$/.match(download_uri.path)[0]
    
    HttpPage.read_to_file download_uri, File.join(@downloads_dir, download_name)
    
    FileUtils.rm_r('api_new') if File.exists? 'api_new'
    
    Zip::ZipFile.foreach(File.join(@downloads_dir, download_name)) do |f|
      fpath = File.join('api_new', f.name)
      FileUtils.mkdir_p(File.dirname(fpath))
      f.extract(fpath)
    end
    
    `mv api api_old`
    `mv api_new api`
    `rm -r api_old`
  end
end
