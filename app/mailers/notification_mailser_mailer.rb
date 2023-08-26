class NotificationMailserMailer < ApplicationMailer
  def notification_email(end_user, notification)
    @end_user = end_user
    @notification  = notification.action_text
    mail to: end_user.email, subject: '〚CodeConnect〛'
  end
end