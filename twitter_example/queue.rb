class Queue
  def establish
    connection = Bunny.new
    connection.start
    channel = connection.create_channel
    @queue = channel.queue('stream_tweets')
  end

  def post(tweet_json)
    @queue.publish(tweet_json)
  end
end
