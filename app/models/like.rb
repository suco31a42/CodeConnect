class Like < ApplicationRecord
  belongs_to :end_user
  belongs_to :post
  has_one    :notification, as: :subject, dependent: :destroy
  
  validates :end_user_id, presence: true
  validates :post_id,     presence: true
  # 一人につき一回だけレコードを追加できる
  validates_uniqueness_of :post_id, scope: :end_user_id
  
  after_create_commit :create_notifications
  
  private
  
  def create_notifications
    Notification.create(subject: self, end_user: self.post.end_user, action_type: :liked_to_own_post)
  end
end
