#!/usr/bin/env ruby
# Git Sparkline
#
# SVN original by Tobin Harris (http://www.tobinharris.com)
# Git version by James Gregory (http://jagregory.com)
#
# Project to generate an activity sparkline for a local Git repository.
#
# Outputs a *javascript snippet* that can be included in a HTML document.
#
# Usage:
#    ruby svn_analyze.rb [Project Name] [repo]
#
# Eg:
#    ruby svn_analyze.rb "Fluent NHibernate" repos/local.git > /htdocs/widget.js
#  
# Once you've output the widget, you can include it in your Javascript like this
#
#    <p>Here is a sparkline: <script src="widget.js"></script>, nice huh!</p>
#

require 'date'
require 'time'

project = ARGV[0] || 'Fluent NHibernate'
repo = ARGV[1] || 'scripts/repos'
branches = ['origin/master', 'origin/v1.1--automapping-strategy', 'origin/v2.0--api']
cmd = 'git log -20 --format="%ci|%an"'
data = []

def seconds_to_human_interval(secs)

  secs = secs * -1 if secs < 0
  
  minute = 60
  hour = minute * 60
  day = hour * 24
  week = day * 7
  month = week * 4
  year = month * 12

  times = [
    {:minute => minute},
    {:hour => hour},
    {:day => day},
    {:week => week},
    {:month => month},
    {:year => year}
    ]
  
  times.reverse.each do |el|        
      return secs / el.values[0].to_i, el.keys[0].to_s if secs >= el.values[0].to_i      
  end
  
  return secs, "second"       
end

class LogEntry
  attr_accessor :author
  attr_accessor :date
end


sparkline_template = %Q{
var txt = 'TEXT';
document.write('<a href="javascript:void(0);" onclick="alert(txt);" title="Fluent NHibernate commit activity"><img src="http://chart.apis.google.com/chart?\
cht=ls\
&chs=30x15\
&chd=t:DATA\
&chds=0,20\
&chls=2\
&chf=bg,s,' + colour + '" alt="" /></a>');
}

# exec git
Dir.chdir(repo) do
  branches.each do |branch|
    IO.popen("#{cmd} #{branch}") do |out|
      out.readlines.each {|l| data << l }
    end
  end
end

entries = Array.new
authors = Array.new
dates = Array.new

data.each do |entry|
  d,a = entry.split('|')

  e = LogEntry.new
  e.author = a.strip
  e.date = Time.parse(d)
  entries << e
end

authors = entries.collect{|e| e.author}
data = seconds_to_human_interval(Time.new - entries.first.date)
end_data = seconds_to_human_interval(Time.new - entries.last.date)

txt = "The #{project} code base was last updated by #{entries.first.author} #{data[0].round} #{data[1]}s ago."
txt = txt + '\n\n'
txt = txt + "#{entries.length} updates by #{authors.uniq.join(', ')} in the last #{end_data[0].round} #{end_data[1]}s."

puts "// nhibernate_stats.js"

#daily data points for last 3 days, count of updates per day
data_points = Array.new
(-30..0).each do |ago|
  to_match = (Time.new - 60*60*24*ago*-1).strftime('%Y-%m-%d')
  found = entries.select{|e| e.date.strftime('%Y-%m-%d') == to_match}
  data_points << found.length
end
puts


puts sparkline_template.sub(/DATA/, data_points.join(",")).sub(/TEXT/,txt)
