require 'twitter'
require 'dotenv'
Dotenv.load

# Authenticate
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

# Random replies
replies = File.open("replies.txt").readlines

# Store the latest tweet
latest_tweet = client.mentions_timeline.first

loop do
  # Poll for a new @mention
  first_tweet = client.mentions_timeline.first

  if first_tweet != latest_tweet
    # Assemble a tweet
    tweet = "@#{first_tweet.user.screen_name} #{replies.sample}"

    # Log the new tweet to the console
    puts "New Tweet!"
    puts first_tweet.text
    puts "From: @#{first_tweet.user.screen_name}"
    puts "Sending reply: \"#{tweet}\""

    # Send reply
    client.update(tweet)

    # Hold onto the latest tweet to check against
    latest_tweet = first_tweet
  end

  puts "Waiting for new @mention..."
  sleep 60
end
