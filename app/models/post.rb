class Post < ApplicationRecord
  has_many_attached :post_images
  belongs_to :end_user
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  validate :image_type, :image_size, :image_length



  # likesの中にend_user.idがあるか聞いている
  def liked_by?(end_user)
    likes.exists?(end_user_id: end_user.id)
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


end
