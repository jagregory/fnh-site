#!/usr/bin/env ruby

require 'utils/read_http.rb'
require 'utils/hasher.rb'
require 'rubygems'
require 'zip/zip'

API_DIR = '../api'
DOWNLOADS_DIR = '../dls'
DOC_HASH_FILE = '../doc_csv.hash'

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
  
  data = HttpPage.read(download_uri.host, download_uri.path)
  
  FileUtils.rm_r('../api_new') if File.exists? '../api_new'
  Dir.mkdir(DOWNLOADS_DIR) unless File.exists? DOWNLOADS_DIR
  File.open(File.join(DOWNLOADS_DIR, download_name), 'w') { |file|
    file.write data
  }
  
  Zip::ZipFile.foreach(File.join(DOWNLOADS_DIR, download_name)) do |f|
    fpath = File.join('../api_new', f.name)
    FileUtils.mkdir_p(File.dirname(fpath))
    f.extract(fpath)
  end
  
  File.delete(File.join(DOWNLOADS_DIR, download_name)) if File.exists?(File.join(DOWNLOADS_DIR, download_name))
  
  puts `mv ../api ../api_old && mv ../api_new ../api && rm -r ../api_old`
end

hash = Hash.generate get_latest_filename()

if Hash.changed? hash, DOC_HASH_FILE
  # new binary available, grab it
  puts 'Getting docs zip'
  download_file('fluentnhibernate-docs-{build.number}.zip')
  Hash.save hash, DOC_HASH_FILE
end