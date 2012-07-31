Rails.application.config.middleware.use OmniAuth::Builder do
  provider :browser_id
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_SECRET_KEY']
end
