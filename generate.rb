#!/usr/bin/env ruby

if File.exists? '.git'
  puts 'Refreshing source before updating site'
  puts `git pull`
  puts
end

require 'scripts/authors_update'

puts 'Generating site'
puts '---------------'
puts
puts '> Updating authors...'

AuthorsUpdater.new.execute

puts
puts '> Running Jekyll...'
`jekyll`
