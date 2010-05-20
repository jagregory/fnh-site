#!/usr/bin/env ruby

require 'utils/read_http.rb'

DOWNLOADS_DIR = '../dls'
MAX_DOWNLOADS_EACH = 25

def get_latest_filename
  path = get_actual_path('fluentnhibernate-source-{build.number}.zip')
  /[^\/]{1,}\.zip$/.match(path)[0]
end

def get_actual_path(filename)
  headers = HttpPage.read_headers('teamcity.codebetter.com', "/guestAuth/repository/download/bt9/.lastSuccessful/#{filename}")
  /(.*);/.match(headers['location'])[1]
end

def is_update?
  not File.exist? File.join(DOWNLOADS_DIR, get_latest_filename())
end

def download_file(filename)
  download_uri = URI.parse(get_actual_path(filename))  
  download_name = /[^\/]{1,}\.zip$/.match(download_uri.path)[0]
  
  data = HttpPage.read(download_uri.host, download_uri.path)
  
  Dir.mkdir(DOWNLOADS_DIR) unless File.exists? DOWNLOADS_DIR
  File.open(File.join(DOWNLOADS_DIR, download_name), 'w') { |file|
    file.write data
  }
end

def prune_downloads_by_name(name)
  files = Dir.glob(File.join(DOWNLOADS_DIR, name)).sort
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

def generate_ul(name)
  files = Dir.glob(File.join(DOWNLOADS_DIR, name)).sort.reverse
  files = files[0..5]

  page_prefix = "source"
  page_prefix = "binary" if name.include? 'binary'

  t = "<ul>"
  
  first = true
  
  files.each { |f|
    path = f.gsub '..', ''
    path = path.gsub 'dls', 'downloads'
    revision = /([0-9]{1,})\.zip$/.match(f)[1]
    text = "Build #{revision}"
    text = "Latest build (##{revision})" if first
    t = t + "<li><a href=\"#{path}\" onclick=\"javascript:pageTracker._trackEvent('Download', '#{page_prefix}', '/downloads/#{page_prefix}/#{revision}');\">#{text}</a></li>"
    
    first = false
  }
  
  t = t + "</ul>"
  
  return t
end

def update_page
  source = generate_ul("fluentnhibernate-source*")
  binary = generate_ul("fluentnhibernate-binary*")
  template = File.open('../templates/downloads.htm', 'r').read
  template = template.gsub('[[SOURCE]]', source)
  template = template.gsub('[[BINARY]]', binary)
  
  File.open('../downloads.htm', 'w').puts template
end

if is_update?
  # new binary available, grab it
  puts 'Getting source zip'
  download_file('fluentnhibernate-source-{build.number}.zip')
  
  puts 'Getting binary zip'
  download_file('fluentnhibernate-binary-{build.number}.zip')
  
  puts 'Pruning downloads'
  prune_downloads
  
  puts 'Updating page'
  update_page
end
