class PostComment < ApplicationRecord
  belongs_to :end_user
  belongs_to :post
  has_one :notification, as: :subject, dependent: :destroy
  
  validates :body, presence: true
  validates :body,   length: { in: 3..255 }
  after_create_commit :create_notifications
  
private
  
  def create_notifications
    Notification.create(subject: self, end_user: post.end_user, action_type: :commented_to_own_post)
  end

end
