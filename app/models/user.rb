class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    where(auth.slice("provider","uid")).first_or_create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
    end
  end
end
