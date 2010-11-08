require 'scripts/utils/read_http.rb'

MAX_DOWNLOADS_EACH = 25

class DownloadUpdater
  def initialize(downloads_dir, branch, build_id)
    @downloads_dir = downloads_dir
    @branch = branch
    @build_id = build_id
  end
  
  def execute
    if true
      puts 'Getting source zip'
#      download_file('fluentnhibernate-source-{build.number}.zip')
      
      puts 'Getting binary zip'
#      download_file('fluentnhibernate-binary-{build.number}.zip')

      puts 'Pruning downloads'
#      prune_downloads

      puts 'Updating page'
      update_page
    else
      puts 'No updates available'
    end
  end

  private
  def has_update?
    not File.exist? File.join(@downloads_dir, get_latest_filename)
  end

  def get_latest_filename
    path = get_actual_path('fluentnhibernate-source-{build.number}.zip')
    /[^\/]{1,}\.zip$/.match(path)[0]
  end
  
  def get_actual_path(filename)
    headers = HttpPage.read_headers('teamcity.codebetter.com', "/guestAuth/repository/download/#{@build_id}/.lastSuccessful/#{filename}")
    /(.*);/.match(headers['location'])[1]
  end
  
  def download_file(filename)
    download_uri = URI.parse(get_actual_path(filename))  
    download_name = /[^\/]{1,}\.zip$/.match(download_uri.path)[0]
    
    Dir.mkdir(@downloads_dir) unless File.exists? @downloads_dir
    HttpPage.read_to_file(download_uri, File.join(@downloads_dir, download_name))
  end

  def prune_downloads_by_name(name)
    files = Dir.glob(File.join(@downloads_dir, name)).sort
    files_to_delete = files[0, files.length - MAX_DOWNLOADS_EACH] || []
    
    files_to_delete.each { |file|
      puts "Deleting #{file}"
      File.delete file
    }
  end

  def prune_downloads
    prune_downloads_by_name 'fluentnhibernate-source*'
    prune_downloads_by_name 'fluentnhibernate-binary*'
  end
  
  def update_page
    source = generate_table_rows("fluentnhibernate-source*", @branch)
    
    table = <<STR
<table id="downloads">
  <thead>
    <tr>
      <th>Compiled</th>
      <th>Source</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      #{source}
    </tr>
  </tbody>
</table>
STR
    
    File.open(File.expand_path("_includes/downloads.#{@branch}.md"), 'w') {|f| f.write table }
  end

  def generate_table_rows(name, build)
    files = Dir.glob(File.join(@downloads_dir, name)).sort.reverse
    files = files[0..5]

    first = true
    t = ""
    
    files.each { |f|
      path = f.gsub '..', ''
      path = path.gsub 'dls', 'downloads'
      bin_path = path.gsub 'source', 'binary'
      
      revision = /([0-9]{1,})\.zip$/.match(f)[1]
      text = "#{build} build #{revision}"
      text = "Latest #{build} build (##{revision})" if first
      t = t + '<tr>'
      t = t + "<td><a href=\"#{bin_path}\" onclick=\"javascript:pageTracker._trackEvent('Download', 'binary', '/downloads/#{@branch}/binary/#{revision}');\">#{text}</a></td>"
      t = t + "<td><a href=\"#{path}\" onclick=\"javascript:pageTracker._trackEvent('Download', 'source', '/downloads/#{@branch}/source/#{revision}');\">#{text}</a></td>"
      t = t + '</tr>'
      
      first = false
    }
    
    return t
  end
end
