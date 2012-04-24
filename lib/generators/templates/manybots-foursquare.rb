# Configure Manybots Foursquare

ManybotsFoursquare.setup do |config|
  # Foursquare OAuth App Id
  config.foursquare_app_id = '<replace me>'
  
  # Foursquare OAuth App Secret
  config.foursquare_app_secret = '<replace me>'
  
  # App nickname
  config.nickname = 'manybots-foursquare'
end

app = ClientApplication.find_or_initialize_by_nickname ManybotsFoursquare.nickname
if app.new_record?
  app.app_type = "Observer"
  app.name = "Foursquare Observer"
  app.description = "Import your checkins from Foursquare"
  app.url = ManybotsServer.url + '/manybots-foursquare'
  app.app_icon_url = ManybotsServer.url + "/assets/manybots-foursquare/icon.png"
  app.developer_name = "Manybots"
  app.developer_url = "https://www.manybots.com"
  app.category = "Lifestyle"
  app.is_public = true
  app.save
end
ManybotsFoursquare.app = app
