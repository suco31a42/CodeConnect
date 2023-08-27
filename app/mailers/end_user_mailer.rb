class EndUserMailer < ApplicationMailer
  def notification_comment_email(end_user, post)
    @end_user = end_user
    @post = post
    mail to: @end_user.email, subject: '新しくコメントが投稿されました！'
  end

  def notification_follow_email(followed, follower)
    @followed = followed
    @follower = follower

    mail to: @followed.email, subject: '新しくフォロワーが増えました！'
  end
end