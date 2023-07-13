class Like < ApplicationRecord
  belongs_to :end_user
  # いいねが増減したとき、like_countも増減する
  belongs_to :post, counter_cache: :likes_count
  # 一人につき一回だけレコードを追加できる
  validates_uniqueness_of :post_id, scope: :end_user_id
end
