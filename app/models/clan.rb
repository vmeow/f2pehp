class Clan < ActiveRecord::Base
  has_many :players

  def self.sanitize_name(str)
    str = ERB::Util.url_encode(str).gsub(/[-_\\+]|(%20)|(%C2%A0)/, " ")
    return str.gsub(/\A[^A-z0-9]+|[^A-z0-9\s\_-]+|[^A-z0-9]+\z/, "")
  end

  def self.find_clan(id)
    id = self.sanitize_name(id)
    splits = id.split(/[\s\_]|(%20)/)
    res = splits.join("_") # _ is a wildcard
    clan = Clan.where("lower(name) like '%#{res.downcase}%' and length(name) = length('#{res.downcase}')").first

    if clan.nil?
      begin
        clan = Clan.find(Float(id))
      rescue
        return false
      end
    end
    return clan
  end
end
