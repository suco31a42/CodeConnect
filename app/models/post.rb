class Post < ApplicationRecord
  has_many_attached :post_images
  belongs_to :end_user
  has_many :likes,         dependent: :destroy
  has_many :bookmarks,     dependent: :destroy
  has_many :post_comments, dependent: :destroy
  # ブックマークした投稿を習得
  has_many :bookmark_posts,  through: :bookmarks,  source: :post
  has_many :liked_end_users, through: :likes,      source: :end_user
  has_one  :notification,         as: :subject, dependent: :destroy

  validate  :image_type, :image_size, :image_length
  validates :body, presence: true, length: { in: 3..255, message: "3文字以上、255文字以内にする必要があります" }


  scope :public_posts, -> { joins(:end_user).where(end_users: { private_status: true}) }
  scope :latest,     -> {order(created_at: :desc)}
  # 一ヶ月以内に作成された投稿を対象にいいねが多い順に並べる
  scope :like_count, -> do
    to = Time.current.at_end_of_day
    from = 1.month.ago.beginning_of_day
    left_outer_joins(:likes)
    .where(likes: { created_at: from..to })
    .order(likes_count: :desc)
    .includes(:end_user)
    .or(left_outer_joins(:likes).where(likes: { id: nil }))
  end
  # likesの中にend_user.idがあるか聞いている
  def liked_by?(end_user)
    likes.exists?(end_user_id: end_user.id)
  end
  def bookmarked_by?(end_user)
    bookmarks.exists?(end_user_id: end_user.id)
  end

  private

  def image_type
    post_images.each do |image|
      unless image.blob.content_type.in?(%('image/jpeg image/png'))
        image.purge
        errors.add(:post_images, 'はjpegまたはpng形式でアップロードしてください')
      end
    end
  end

  def image_size
    post_images.each do |image|
      if image.blob.byte_size > 5.megabytes
        image.purge
        errors.add(:post_images, "は1つのファイル5MB以内にしてください")
      end
    end
  end

  def image_length
    if post_images.length > 4
      images.purge
      errors.add(:post_images, "は1投稿に付き4枚以内にしてください")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at"]
  end

end
