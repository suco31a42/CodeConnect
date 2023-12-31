class PostComment < ApplicationRecord
  belongs_to :end_user
  belongs_to :post
  has_one :notification, as: :subject, dependent: :destroy

  validates :body, presence: true, length: { in: 2..250, message: "2文字以上、250文字以内にする必要があります" }
  after_create_commit :create_notifications

private

  def create_notifications
    # 自分自身に対するコメントなら通知を作成しない
    return if end_user == post.end_user
    Notification.create(subject: self, end_user: post.end_user, action_type: :commented_to_own_post)
    if post.end_user.email_status == ("0" || "1")
      EndUserMailer.notification_comment_email(post.end_user, post).deliver_now
    end
  end

end
