# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
5.times do |n|
  EndUser.create!(
    email:          "test#{n + 1}@test.com",
    name:           "テスト太郎#{n + 1}",
    unique_id:      "test_id#{n + 1}",
    password:       "password#{n + 1}",
    date_of_dirth:  "value" "2017-07-19",
    introduction:   "#{n + 1}よろしくお願いします！",
    private_status: true,
    is_deleted:     false
      )
end

Post.create(
  end_user_id: 1,
  body: "テキストテキストテキストテキスト"
)
