class Post
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :user_id, :type => Integer
  field :post, :type => String
  field :post_time, :time => Time
end
