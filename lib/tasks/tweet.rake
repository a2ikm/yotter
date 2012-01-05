task :tweet => :environment do
  User.active.each do |user|
    user.tweet
  end
end
