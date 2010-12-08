#!/usr/bin/env ruby

if File.exists? '.git'
  puts 'Refreshing source before updating site'
  puts `git pull`
  puts
end

require 'scripts/authors_update'
require 'scripts/download_update'
require 'scripts/doc_update'

puts 'Generating site'
puts '---------------'
puts
puts '> Updating authors...'

AuthorsUpdater.new.execute

puts
puts '> Updating v1.x downloads...'

MultiDownloadUpdater.new('dls/v1.x', 'v1.x', { 'NH2.1' => 'bt281', 'NH3.0' => 'bt295' }).execute

puts
puts '> Updating master downloads...'

DownloadUpdater.new('dls/master', 'master', 'bt9').execute

puts
puts '> Updating docs...'

DocsUpdater.new('dls/v1.x').execute

puts
puts '> Running Jekyll...'
`jekyll`
