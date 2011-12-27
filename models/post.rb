class Post
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :user_id, :type => Integer
  field :post, :type => String
  field :bury_time, :type => Time
  field :post_time, :type => Time
end
