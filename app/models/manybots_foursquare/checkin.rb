module ManybotsFoursquare
  class Checkin
    
    attr_accessor :checkin

    def initialize(fs_user_id, fs_checkin, user)
      @fs_user_id, @checkin, @user = fs_user_id, fs_checkin, user
    end
  
    def as_activity
      activity = {
        published: Time.at(self.checkin.createdAt).xmlschema,
        verb: 'checkin',
        tags: [].push(self.checkin.private? ? 'private' : 'public'),
        title: 'ACTOR checked in to OBJECT',
        auto_title: true,
        id: "tag:foursquare.com;#{Time.at(self.checkin.createdAt).year}:checkin/#{self.checkin.id}",
        url: "http://foursquare.com/user/#{@fs_user_id}/checkin/#{self.checkin.id}"
      }
      puts self.checkin.inspect
      if self.checkin['type'] == 'venueless'
        activity[:object] = {
          objectType: 'place' ,
          displayName: self.checkin.location.name || "Unknown Location",
          id: activity[:id],
          url: activity[:url],
          position: "#{self.checkin.location.lat} #{self.checkin.location.lng}",
        }
        
      else        
        activity[:object] = {
          objectType: 'place' ,
          displayName: self.checkin.venue.name || "Unknown Location",
          id: "tag:foursquare.com;#{Time.now.year}:v/#{self.checkin.venue.id}",
          url: "http://foursquare.com/v/#{self.checkin.venue.id}",
          position: "#{self.checkin.venue.location.lat} #{self.checkin.venue.location.lng}",
        }
      end
      activity[:generator] = ManybotsFoursquare.app.as_generator
      activity[:provider] = {
        displayName: "Foursquare",
        url: "http://foursquare.com",
        image: {
          url: ManybotsServer.url + ManybotsFoursquare.app.app_icon_url,
        }
      }
      activity
    end
    
    def manybots_client
      @manybots_client ||= Manybots::Client.new(@user.authentication_token)
    end

    def post_to_manybots!
      self.manybots_client.create_activity self.as_activity
    end
    
  end
end