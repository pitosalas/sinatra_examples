class TweetQueue
  def establish
    connection = Bunny.new
    connection.start
    channel = connection.create_channel
    @queue = channel.queue('stream_tweets')
  end

  def listen
    puts " Waiting for messages ..."
    @queue.subscribe(block: true) do |_delivery_info, _properties, body|
      puts " [x] Received #{body}"
    end
  rescue Interrupt => _e
    connection.close
    exit(0)
  end

  def post(tweet_json)		
    @queue.publish(tweet_json)		
  end
end
