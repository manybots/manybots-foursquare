class FoursquareWorker
  require 'foursquare2'
  
  @queue = :observers
  
  attr_accessor :account
  
  def initialize(oauth_account_id)
    @account = OauthAccount.find(oauth_account_id)
  end
  
  def client
    @client ||= Foursquare2::Client.new oauth_token: @account.token
  end
  
  def fs_user_id
    @fs_user_id ||= self.client.user('self').id
  end
  
  def min_id
    @account.payload[:min_id]
  end
  
  def min_id=(id)
    @account.payload[:min_id] = id
    @account.save and @account.reload
    id
  end
  
  def reset_ids!
    self.min_id=nil
  end
  
  def get_recent_checkins(options={})
    params = {limit: 30}
    results = self.client.user_checkins(params.merge(options))
    @fetched += results.items.size
    results
  end
  
  def get_all_checkins
    @fetched = 0
    @times_ran = 0
    params = {}
    params[:afterTimestamp] = self.min_id if self.min_id.is_a? Integer
    results = self.get_recent_checkins(params)
    @count = results['count']
    @fetched = results['items'].size
    results = results.items
    results.delete_at(-1) if results.last.createdAt == self.min_id
    unless results.empty?
      while @fetched < @count and @times_ran < 30
        results += self.get_recent_checkins(params.merge(offset: @fetched)).items
        @times_ran += 1
      end
    end
    results
  end
  
  def self.perform(oauth_account_id)
    worker = self.new(oauth_account_id)
    checkins = worker.get_all_checkins
    for checkin in checkins
      ManybotsFoursquare::Checkin.new(worker.fs_user_id, checkin, worker.account.user).post_to_manybots!
    end
    worker.min_id = checkins.first.createdAt 
  end  
    
end