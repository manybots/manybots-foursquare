module ManybotsFoursquare
  class FoursquareController < ApplicationController
    require 'oauth2'
    require 'foursquare2'
    
    before_filter :authenticate_user!
    
    FS_REDIRECT_URI = "#{ManybotsFoursquare.app.url}/foursquare/callback"
    
    def index
      @foursquares = current_user.oauth_accounts.where(:client_application_id => current_app.id)
      @schedules = ManybotsServer.queue.get_schedules
    end
    
    def new
      consumer = get_consumer
      redirect_to consumer.auth_code.authorize_url(redirect_uri: FS_REDIRECT_URI)
    end
    
    def toggle
      foursquare = current_user.oauth_accounts.find(params[:id])
      load_schedule(foursquare)
      message = 'Please try again.'
      if @schedule
        ManybotsServer.queue.remove_schedule @schedule_name
        foursquare.status = 'off'
        message = 'Stoped importing.'
      else 
        foursquare.status = 'on'
        message = 'Started importing.'        
            
        ManybotsServer.queue.add_schedule @schedule_name, {
          :every => '6h',
          :class => "FoursquareWorker",
          :queue => "observers",
          :args => foursquare.id,
          :description => "Import checkins from Foursquare for OauthAccount ##{foursquare.id}"
        }
      
        ManybotsServer.queue.enqueue(FoursquareWorker, foursquare.id)
      end
      
      foursquare.save
      
      redirect_to root_path, :notice => message
      
    end
    
    def callback
      consumer = get_consumer
      token = consumer.auth_code.get_token(params[:code], redirect_uri: FS_REDIRECT_URI)
      client = Foursquare2::Client.new oauth_token: token.token
      profile = client.user('self')

      foursquare = current_user.oauth_accounts.find_or_create_by_client_application_id_and_remote_account_id(current_app.id, profile.id)
      foursquare.token = token.token
      foursquare.payload['name'] = "#{profile.firstName} #{profile.lastName}"
      foursquare.save
      
      redirect_to foursquare_index_path, notice: "Foursquare account '#{foursquare.payload['name']}' registered."
    end
    
    def destroy
      foursquare = current_user.oauth_accounts.find(params[:id])
      load_schedule(foursquare)
      ManybotsServer.queue.remove_schedule @schedule_name if @schedule
      foursquare.destroy
      redirect_to root_path, notice: 'Account deleted.'
    end
    
  private
    
    def load_schedules
      ManybotsServer.queue.get_schedules
    end
    
    def load_schedule(oauth_account)
      schedules = load_schedules
      @schedule_name = "import_manybots_foursquare_#{oauth_account.id}"
      @schedule = schedules.keys.include?(@schedule_name) rescue(false)
    end
    
    
    def current_app
      @manybots_foursquare_app ||= ManybotsFoursquare.app
    end
    
    def get_consumer
      @consumer ||= OAuth2::Client.new(ManybotsFoursquare.foursquare_app_id, ManybotsFoursquare.foursquare_app_secret, 
        :site => "https://foursquare.com",
        :authorize_url => "/oauth2/authorize",
        :token_url => "/oauth2/access_token"
      )
    end    
  end
end
