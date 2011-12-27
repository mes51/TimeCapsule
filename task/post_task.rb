module PostTask
  def self.run
    posts = Post.where({ :post_time.lte => Time.now }).to_a
    user_ids = posts.inject([]) { |a, v| a << v.user_id; a }
    user = User.where({ :user_id.in => user_ids }).inject({}) { |h, v| h[v.user_id] = v; h }
    
    posts.each do |p|
      u = user[p.user_id]
      Twitter.configure do |conf|
        conf.consumer_key = TimeCapsuleEnv[:auth]["key"]
        conf.consumer_secret = TimeCapsuleEnv[:auth]["secret"]
        conf.oauth_token = u.access_key
        conf.oauth_token_secret = u.access_key_secret
      end
      Twitter.update("タイムカプセルを開封しました! " + p.post)
      p.remove
    end
  end
end
