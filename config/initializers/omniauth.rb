Rails.application.config.middleware.use OmniAuth::Builder do
  # TODO production keys
  # https://code.google.com/apis/console/
  # https://dev.twitter.com/apps
  #provider :browser_id, :verify_url => 'https://verifier.login.persona.org/verify'
  provider :openid, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  provider :twitter, Figaro.env.twitter_consumer_key, Figaro.env.twitter_secret_key
end