class PostComment < ApplicationRecord
  belongs_to :end_user
  belongs_to :post
  has_one :notification, as: :subject, dependent: :destroy
  
  after_create_commit :create_notifications
  
private
  
  def create_notifications
    Notification.create(subject: self, end_user: post.end_user, action_type: :commented_to_own_post)
  end

end
