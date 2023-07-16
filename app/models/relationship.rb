class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "EndUser"
  belongs_to :followed, class_name: "EndUser"
  has_one :notification, as: :subject, dependent: :destroy
  validates :follower,    presence: true
  validates :followed,    presence: true
  validates :follower_id, uniqueness: { scope: :followed_id }
  validate  :cannot_follow_self
  after_create_commit :create_notifications
  
private

  def create_notifications
    Notification.create(subject: self, end_user: followed, action_type: :follwed_me)
  end
  # フォロー元とフォロー先のユーザーが同じであるか確認する
  def cannot_follow_self
    if self == followed_end_user
      errors.add(:base, "自分自身をフォローすることはできません")
    end
  end
end
