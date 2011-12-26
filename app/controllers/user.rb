TimeCapsule.controllers :user do
  get :get_info do
    content_type :json
    user_info = {}

    user = env["rack.session"].to_hash[:user]
    if user
      user_info[:user_id] = user.user_id
      user_info[:screen_name] = user.screen_name
    end

    Yajl::Encoder.encode user_info
  end

  get :login do
    redirect "/auth/request_key"
  end

  get :logout do
    env["rack.session"][:user] = nil
  end
end
