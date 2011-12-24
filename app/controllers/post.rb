TimeCapsule.controllers do
  DAY = 24 * 3600

  post :post do
    unless env["rack.session"][:user]
      redirect "/"
      return
    end

    user = env["rack.session"][:user]
    post = Post.new({ :user_id => user.user_id,
                      :post => params["post"],
                      :post_time => Time.now + params["post_time"].to_i * DAY })
    post.save
  end
end
