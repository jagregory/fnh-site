#!/usr/bin/env ruby

authors = []

Dir.chdir('repos') do
  `git fetch`
  authors = `git rev-list origin/master --pretty=short | grep 'Author: ' | sed 's/Author: //g' | sed 's/ <.*>//g' | sort | uniq`.split(/\n/)
end

puts authors

# remove invalid or duplicate users
authors.delete "(no author)"
authors.delete "HudsonAkridge"
authors.delete "childss"
authors.delete "JSkinner"
authors.delete "Musgrove@.(none)"
authors.delete "unknown"
authors[-1] = "and #{authors.last}" # sentencize it

formatted_authors = authors.join(', ')

template = File.open('../templates/index.htm', 'r').read
template = template.gsub('[[committers]]', formatted_authors)

File.open('../index.htm', 'w').puts template
