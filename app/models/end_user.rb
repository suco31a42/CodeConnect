class EndUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :default_image
  attr_writer :login

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  validates :password, format: { with: VALID_PASSWORD_REGEX, message: 'は半角英数を両方含む必要があります'}, allow_blank: true
  
  validates :unique_id, presence: true, uniqueness: { case_sensitive: false }
  # unique_idは英数字、アンダースコア、句読点のみ使用できます
  validates_format_of :unique_id, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validate :validate_unique_id
  
  has_one_attached :profile_image
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  
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
  # emailかuniqur_idどちらかあるか？
  def validate_unique_id
    if EndUser.where(email: unique_id).exists?
      errors.add(:unique_id, :invalid)
    end
  end
  # ユーザが新規登録される際にデフォルト画像を追加する
  def default_image
    if !self.profile_image.attached?
      self.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/no_image.jpg')), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
  end


  
end
