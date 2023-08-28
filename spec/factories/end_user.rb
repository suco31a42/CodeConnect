FactoryBot.define do
  factory :end_user do
    name { "結月ゆかり" }
    unique_id { "yukari" }
    email { "yukarisan@vocaloid.com" }
    password { "password1" }
  end
end