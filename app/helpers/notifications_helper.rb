module NotificationsHelper
  def transition_path(notification)
    # action_typeをシンボルに変換してアクションを判断する
    case notification.action_type.to_sym
    when :commented_to_own_post
      post_path(notification.subject.post) # コメントされた投稿のページ
    when :liked_to_own_post
      post_path(notification.subject.post) # いいねされた投稿のページ
    when :followed_me
      end_user_path(notification.subject.follower) # フォローワーのページ
    end
  end
end
