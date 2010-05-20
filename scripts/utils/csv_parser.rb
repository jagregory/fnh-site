require 'rubygems'
require 'fastercsv'

class CSV
  def self.parse(data, options)
    rows = FasterCSV.parse(data)
    
    unless options[:exclude].nil?
      columns = []
      
      # get indicies of excluded columns
      options[:exclude].each do |column|
        rows[0].each_index { |i| columns << i if rows[0][i] == column }
      end
      
      rows.map! do |row|
        row = row.each_index { |i| row[i] = nil if columns.include? i }.compact
      end
    end
    
    return rows.compact
  end
end