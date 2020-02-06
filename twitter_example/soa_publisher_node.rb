require 'twitter'
require 'bunny'
require 'pry-byebug'
require_relative 'twitter_api'
require_relative 'tweet_queue'

class SoaPublisher
  def run
    @xface = TwitterApi.new
    @queue = TweetQueue.new
    @queue.establish
    @xface.stream_connect
    @xface.for_each_tweet do |t|
      @queue.post(@xface.tweet_to_json(t))
    end
  end
end

SoaPublisher.new.run
