#!/usr/bin/env ruby

require 'utils/csv_parser.rb'
require 'utils/read_http.rb'
require 'utils/hasher.rb'

ISSUES_HASH_FILE = '../issues_csv.hash'

def generate_table(data)
  rows = CSV.parse data, :exclude => ["Type", "Status", "Priority", "Milestone", "Owner"]

  html = "<table id=\"issues\"><thead><tr>"
  rows[0].each { |cell| html << "<th>#{cell}</th>"}
  html << "</tr></thead><tbody>"
  
  counter = 1
  alt = false
  
  rows.each_index do |i|
    next if i == 0
    
    row = rows[i]
    url = "http://code.google.com/p/fluent-nhibernate/issues/detail?id=#{row[0]}"
    
    if alt == false
      html << "<tr>"
    else
      html << "<tr class=\"alt\">"
    end
    
    if counter == 3
      counter = 0
      alt = !alt
    end
    
    row.each_index do |i|
      value = i == 0 ? "##{row[i]}" : row[i]
      css = i == 0 ? 'id' : 'summary'
      
      html << "<td class=\"#{css}\"><a href=\"#{url}\">#{value}</a></td>"
    end
    html << "</tr>"
    
    counter += 1
  end
  html << "</tbody></table>"
  
  return html
end

def generate_page(data)
  table = generate_table(data)
  template = File.open('../templates/issues.htm', 'r').read
  template = template.gsub('[[TABLE]]', table)
  
  File.open('../issues.htm', 'w').puts template
end

data = HttpPage.read('code.google.com', '/p/fluent-nhibernate/issues/csv')
hash = Hash.generate data

if Hash.changed? hash, ISSUES_HASH_FILE
  generate_page(data)
  Hash.save hash, ISSUES_HASH_FILE
end