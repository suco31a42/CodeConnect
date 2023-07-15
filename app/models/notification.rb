class Notification < ApplicationRecord
  belongs_to :end_user
  belongs_to :subject, polymorphic: true
  
  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, follwed_me: 3 }
end
