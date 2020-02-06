require 'twitter'
require 'bunny'
require 'pry-byebug'
require_relative 'xface_api'
require_relative 'queue'

class SoaDemo
  def run
    @xface = XfaceApi.new
    @queue = Queue.new
    @queue.establish
    @xface.stream_connect
    @xface.for_each_tweet do
      |t| 
      puts @xface.tweet_to_json(t)
      @queue.post(@xface.tweet_to_json(t))
    end
  end
end

SoaDemo.new.run
