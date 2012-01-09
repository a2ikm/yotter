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

  def access_token
    @access_token ||= OAuth::AccessToken.from_hash(
                        ::Yotter::OAUTH_CONSUMER,
                        oauth_token: token,
                        oauth_token_secret: secret
                      )
  end

  def tweet
    access_token.request(
      :post,
      'http://api.twitter.com/1/statuses/update.json',
      "Content-Type" => "application/json",
      "status" => "よったー)^o^("
    )
  end
end
