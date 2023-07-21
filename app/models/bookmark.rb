class Bookmark < ApplicationRecord
  belongs_to :end_user
  belongs_to :post
  # 一人につき一回だけレコードを追加できる
  validates_uniqueness_of :post_id, scope: :end_user_id
end
