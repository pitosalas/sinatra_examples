require 'twitter'
require 'bunny'
require 'pry-byebug'
require_relative 'xface_api'
require_relative 'queue'

class SoaSubscriberNode
  def run
    @xface = XfaceApi.new
    @queue = Queue.new
    @queue.establish
    @xface.stream_connect
<<<<<<< HEAD:twitter_example/soa_demo.rb
    @xface.for_each_tweet do
      |t| 
      puts @xface.tweet_to_json(t)
=======
    @xface.for_each_tweet do |t|
>>>>>>> cfbfbdea3de230eaf38c79671d0713e7ad1db652:twitter_example/soa_subscriber_node.rb
      @queue.post(@xface.tweet_to_json(t))
    end
  end
end

SoaSubscriberNode.new.run
