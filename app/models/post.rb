class Post < ApplicationRecord
  has_many_attached :post_images
  belongs_to :end_user
  has_many :likes,         dependent: :destroy
  has_many :bookmarks,     dependent: :destroy
  has_many :post_comments, dependent: :destroy
  # ブックマークした投稿を取得する
  has_many :bookmark_posts,  through: :bookmarks,  source: :post
  has_many :liked_end_users, through: :likes,      source: :end_user
  has_one  :notification,         as: :subject, dependent: :destroy

  validate  :image_type, :image_size, :image_length
  validates :body, presence: true, length: { in: 2..500, message: "2文字以上、500文字以内にする必要があります" }

# 公開状態かつ、退会していないユーザーの投稿だけ取得する
  scope :public_posts, -> { joins(:end_user).where(end_users: { private_status: false, is_deleted: false }) }
  scope :latest,       -> { order(created_at: :desc) }
  scope :like_count,   -> { posts_like_count }
  scope :follows,      -> { posts_current_end_user_follow }

  # likesの中にend_user.idがあるか聞いている
  def liked_by?(end_user)
    likes.exists?(end_user_id: end_user.id)
  end

  def bookmarked_by?(end_user)
    bookmarks.exists?(end_user_id: end_user.id)
  end
  
  def latest_comment
    post_comments.order(created_at: :desc).first
  end

  private

  def image_type
    post_images.each do |image|
      unless image.blob.content_type.in?(%('image/jpeg image/png'))
        image.destroy
        errors.add(:post_images, 'はjpegまたはpng形式でアップロードしてください')
      end
    end
  end

  def image_size
    post_images.each do |image|
      if image.blob.byte_size > 3.megabytes
        image.destroy
        errors.add(:post_images, "は1つのファイル3MB以内にしてください")
      end
    end
  end

  def image_length
    if post_images.length > 4
      post_images.each do |image|
        image.destroy
        errors.add(:post_images, "は1投稿に付き4枚以内にしてください")
      end
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "likes_count"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["end_user"]
  end
  # 一ヶ月以内に作成された投稿を対象にいいねが多い順に並べる
  def self.posts_like_count
    to   = Time.current.at_end_of_day
    from = 1.month.ago.beginning_of_day
    left_outer_joins(:likes).where(likes: { created_at: from..to })
                            .order(likes_count: :desc)
                            .includes(:end_user)
                            .or(left_outer_joins(:likes).where(likes: { id: nil }))
  end

  def self.posts_current_end_user_follow
    self.where(end_user_id: [current_end_user.id, *current_end_user.
               following_end_users_ids]).order(created_at: :desc)

  end

end
