TimeCapsule.controllers do
  DAY = 24 * 3600

  post :post do
    user = env["rack.session"].to_hash[:user]
    if user && params["post"] && params["post_time"] && params["post_time"].to_i > 0
      post = Post.new({ :user_id => user.user_id,
                        :post => params["post"],
                        :post_time => Time.now + params["post_time"].to_i * DAY })
      post.save
    else
      halt 403
    end
  end
end
