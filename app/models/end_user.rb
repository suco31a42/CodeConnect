class EndUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :default_image
  attr_writer   :login

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  VALID_EMAIL_REGEX    = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :password,       presence: true, length: { in: 6..100 },  format: { with: VALID_PASSWORD_REGEX, message: 'は半角英数を両方含む必要があります'}, allow_blank: true
  validates :email,          presence: true, length: { minimum: 3 }, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :unique_id,      presence: true, length: { in: 6..20 },  uniqueness: { case_sensitive: false }
  validates :name,           presence: true, length: { in: 2..10 }
  validates :is_deleted,     inclusion: { in: [true, false] }
  validates :private_status, inclusion: { in: [true, false] }
  validate  :validate_unique_id
  # unique_idは英数字、アンダースコア、句読点のみ使用できます
  validates_format_of :unique_id, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  
  has_one_attached :profile_image
  has_many :posts,             dependent: :destroy
  has_many :likes,             dependent: :destroy
  has_many :bookmarks,         dependent: :destroy
  has_many :bookmark_posts,      through: :bookmarks, source: :post # ブックマークした投稿を習得
  has_many :post_comments,     dependent: :destroy
  has_many :notifications
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy #フォローした
  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy #フォローされた
  has_many :following_end_users, through: :followers, source: :followed #フォロー画面
  has_many :follower_end_users,  through: :followeds, source: :follower #フォロワー画面
  # 公開、非公開に切り替える
  scope :pulished,   -> { where(private_status: true) }
  scope :unpulished, -> { where(private_status: false) }
  
  # emailかuniqur_idどちらか選べるようにしている
  def login
    @login || self.unique_id || self.email
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(unique_id) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:unique_id) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def active_for_authentication?
    super && (is_deleted == false)
  end
    
  # ユーザが新規登録される際にデフォルト画像を追加する
  def default_image
    if !self.profile_image.attached?
      self.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/no_image.jpg')), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
  end
  # フォローする
  def follow(end_user_id)
    followers.create(followed_id: end_user_id)
  end
  # フォロー解除
  def unfollow(end_user_id)
    followers.find_by(followed_id: end_user_id).destroy
  end
  # フォローしているか確認
  def following?(end_user)
    following_end_users.include?(end_user)
  end
  
  def shot_introduction
    introduction[0,20] + '...'
  end
  
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |end_user|
      end_user.unique_id = "guest_id"
      end_user.password = SecureRandom.urlsafe_base64
      end_user.name = "ゲスト"
    end
  end
  
private
  
  # emailかuniqur_idどちらかあるか？
  def validate_unique_id
    if EndUser.where(email: unique_id).exists?
      errors.add(:unique_id, :invalid)
    end
  end

end
