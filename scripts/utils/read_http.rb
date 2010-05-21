require 'net/http'
require 'uri'

class HttpPage
  def self.read_to_file(url, path)
    `curl -0 #{url} -o #{path}`
  end

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
