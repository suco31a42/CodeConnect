class EndUserMailer < ApplicationMailer
  def notification_email(end_user, post)
    @end_user = end_user
    @post = post
    mail to: @end_user.email, subject: '新しいに通知があります。'
  end
end