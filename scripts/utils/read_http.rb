require 'net/http'
require 'uri'

class HttpPage
  def self.read(host, page)
    headers, data = read_get(host, page)

    return data
  end
  
  def self.read_headers(host, page)
    headers, data = read_get(host, page)

    return headers
  end
  
  def self.read_get(host, page)
    resource = Net::HTTP.new(host, 80)
    headers, data = resource.get(page)

    return headers, data
  end
end