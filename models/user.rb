class User
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :user_id, :type => Integer
  field :screen_name, :type => String
  field :access_key, :type => String
  field :access_key_secret, :type => String
end
