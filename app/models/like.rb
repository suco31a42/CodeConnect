class Like < ApplicationRecord
  belongs_to :end_user
  belongs_to :post
  # 一人につき一回だけレコードを追加できる
  validates_uniqueness_of :post_id, scope: :end_user_id
  has_many :notifications, as: :subject
  
  has_one :notification, as: :subject, dependent: :destroy
  after_create_commit :create_notifications
  
  private
  
  def create_notifications
    Notification.create(subject: self, end_user: self.post.end_user, action_tyoe: :liked_to_own_post)
  end
end
