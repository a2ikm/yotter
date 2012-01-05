# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  scope :active, where(active: true)

  def self.find_or_create_by_omniauth(auth)
    find_by_omniauth(auth) || create_by_omniauth(auth)
  end

  def self.find_by_omniauth(auth)
    find_by_uid(auth["uid"])
  end

  def self.create_by_omniauth(auth)
    create(
      uid:      auth["uid"],
      nickname: auth["info"]["nickname"],
      token:    auth["credentials"]["token"],
      secret:   auth["credentials"]["secret"]
    )
  end

  def activate
    update_attributes!(active: true)
  end

  def deactivate
    update_attributes!(active: false)
  end

  def tweet
    consumer = OAuth::Consumer.new ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'],
                  signature_method: OAuth::SignatureMethod::HMAC::SHA1,
                  token: OAuth::Token.new(token, secret)
    consumer.post 'http://api.twitter.com/1/statuses/update.format',
      status: "よったー)^o^("
  end
end
