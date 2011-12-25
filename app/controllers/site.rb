TimeCapsule.controllers :site do
  get :top, :map => "/" do
    erb :index
  end
end
