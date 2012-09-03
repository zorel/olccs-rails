Rails.application.config.middleware.use OmniAuth::Builder do
  # TODO production keys
  # https://code.google.com/apis/console/
  # https://dev.twitter.com/apps
  #provider :browser_id, :verify_url => 'https://verifier.login.persona.org/verify'
  #provider :google, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
  provider :openid, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_SECRET_KEY']
end