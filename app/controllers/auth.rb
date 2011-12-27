TimeCapsule.controllers :auth do
  get :request_key do
    consumer = OAuth::Consumer.new(TimeCapsuleEnv[:auth]["key"],
                                   TimeCapsuleEnv[:auth]["secret"],
                                   { :site => "http://twitter.com",
                                     :authorize_path => "/oauth/authenticate" })
    request_key = consumer.get_request_token(:oauth_callback => TimeCapsuleEnv[:url] + "auth/authorize_accesskey")
    env["rack.session"][:auth_request] = { :consumer => consumer,
                                           :request_key => request_key }
    redirect(request_key.authorize_url)
  end

  get :authorize_accesskey do
    unless env["rack.session"][:auth_request]
      halt 403
    end

    auth = env["rack.session"][:auth_request]
    req = auth[:request_key]
    access = req.get_access_token(:oauth_verifier => params["oauth_verifier"])

    Twitter.configure do |conf|
      conf.consumer_key = TimeCapsuleEnv[:auth]["key"]
      conf.consumer_secret = TimeCapsuleEnv[:auth]["secret"]
      conf.oauth_token = access.token
      conf.oauth_token_secret = access.secret
    end

    user_info = Twitter.user

    user = User.new({ :user_id => user_info.id,
                      :screen_name => user_info.screen_name,
                      :access_key => access.token,
                      :access_key_secret => access.secret })

    unless User.where({ :user_id => user_info.id })
      user.save
    end

    env["rack.session"][:auth_request] = nil
    env["rack.session"][:user] = user

    redirect("/")
  end
end
