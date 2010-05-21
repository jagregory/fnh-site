#!/usr/bin/env ruby
require 'scripts/authors_update'
require 'scripts/download_update'
require 'scripts/doc_update'

DOWNLOADS_DIR = 'dls'

puts 'Generating site'
puts '---------------'
puts
puts '> Updating authors...'

AuthorsUpdater.new.execute

puts
puts '> Updating downloads...'

DownloadUpdater.new.execute

puts
puts '> Updating docs...'

DocsUpdater.new.execute

puts
puts '> Running Jekyll...'
`jekyll`
