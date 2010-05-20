require 'digest/sha1'

class Hash
  def self.generate(data)
    Digest::SHA1.hexdigest data
  end
  
  def self.changed?(hash, file)
    return true unless File.exists? file
    
    original_hash = File.open(file, 'r').read.chomp
    
    return hash != original_hash
  end
  
  def self.save(hash, file)
    File.open(file, 'w').puts hash
  end
end