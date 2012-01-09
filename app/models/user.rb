# -*- coding: utf-8 -*-

require 'pp'

class User < ActiveRecord::Base
  scope :active, where(active: true)

  def self.update_or_create_by_omniauth(auth)
    find_and_update_by_omniauth(auth) || create_by_omniauth(auth)
  end

  def self.find_and_update_by_omniauth(auth)
    user = find_by_omniauth(auth)
    user.update_by_omniauth(auth) if user.present?
    user
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

  def update_by_omniauth(auth)
    update_attributes(
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
    consumer = OAuth::Consumer.new(
                  ENV['TWITTER_KEY'],
                  ENV['TWITTER_SECRET'],
                  site: "http://api.twitter.com",
                  scheme: :header
                )
    access_token = OAuth::AccessToken.from_hash(
                      consumer,
                      oauth_token: token,
                      oauth_token_secret: secret
                    )
    access_token.request(
      :post,
      'http://api.twitter.com/1/statuses/update.xml',
      "Content-Type" => "application/xml",
      "status" => "よったー)^o^("
    )
  end
end
