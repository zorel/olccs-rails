  class User < ActiveRecord::Base
  has_many :rules
  attr_accessible :rules_attributes
  accepts_nested_attributes_for :rules, allow_destroy: true

  def md5
    Digest::MD5.hexdigest("#{self.provider}#{self.uid}")
  end

  def self.from_omniauth(auth)
    where(auth.slice("provider","uid")).first_or_create! do |user|
      user.provider = auth[:provider]
      user.uid = auth[:uid]
      user.name = auth[:info][:name]
    end
  end


end
