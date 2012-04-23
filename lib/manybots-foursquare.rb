require "manybots-foursquare/engine"

module ManybotsFoursquare
  # Foursquare App Id for OAuth2
  mattr_accessor :foursquare_app_id
  @@foursquare_app_id = nil

  # Foursquare App Secret for OAuth2
  mattr_accessor :foursquare_app_secret
  @@foursquare_app_secret = nil
  
  mattr_accessor :app
  @@app = nil
  
  mattr_accessor :nickname
  @@nickname = nil
  
  
  def self.setup
    yield self
  end
end
