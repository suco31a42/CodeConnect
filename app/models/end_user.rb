class EndUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attr_writer :login
  validates :unique_id, presence: true, uniqueness: { case_sensitive: false }
  # 文字、数字、アンダースコア、句読点のみ使用できます
  validates_format_of :unique_id, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validate :validate_unique_id
  
  has_one_attached :profile_image
  has_many :posts, dependent: :destroy
  
  
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
  
  def validate_unique_id
  if EndUser.where(email: unique_id).exists?
    errors.add(:unique_id, :invalid)
  end
end
  
end
