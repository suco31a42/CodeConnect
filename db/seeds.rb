# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
EndUser.create!(
  [
    {
      email:          "naomiyokochi_51553364@examle.com",
      name:           "ナオミ",
      unique_id:      "Y.naomi",
      password:       "password1",
      date_of_birth:   "1994-07-19",
      introduction:   "よろしくお願いします！私はプログラミングが大好きで、特にWeb開発に興味があります。趣味はアニメを観ることとカフェ巡りです。よろしくお願いしますね！",
      private_status: true,
      is_deleted:     false,
      profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("db/images/end_user/NCG154.jpg"),filename: "NCG154.jpg")
    },
    {
      email:          "john_doe@example.com",
      name:           "John",
      unique_id:      "johndoe_123",
      password:       "securepass123",
      date_of_birth:  "1985-12-03",
      introduction:   "こんにちは、ジョンです！クールなアプリを作り、複雑な問題を解決することに情熱を燃やすソフトウェアエンジニアです。余暇にはビデオゲームを楽しんだり、街の新しいレストランを試してみたりしています。ここで他の開発者とつながることを楽しみにしています！",
      private_status: true,
      is_deleted:     false,
      profile_image:  ActiveStorage::Blob.create_and_upload!(io: File.open("db/images/end_user/pccat.jpg"), filename: "pccat.jpg")
    },
    {
      email:          "sakura_456@example.com",
      name:           "さくら",
      unique_id:      "sakura_456",
      password:       "passsakura356",
      date_of_birth:  "2000-02-28",
      introduction:   "こんにちは！さくらといいます。まだプログラミングを初めて1ヶ月の初心者ですがエンジニアになる夢に向かって頑張ります！",
      private_status: true,
      is_deleted:     false,
      profile_image:  ActiveStorage::Blob.create_and_upload!(io: File.open("db/images/end_user/溶けちゃったアイスさん.png"), filename: "溶けちゃったアイスさん.png")
    },
    {
      email:          "sugioka_yuka_17035797@examle.com",
      name:           "すぎお@休職中",
      unique_id:      "tensyokusitai",
      password:       "111qqq",
      date_of_birth:  "1996-03-09",
      introduction:   "体調不良のため現在休職中です。",
      private_status: true,
      is_deleted:     false,
      profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("db/images/end_user/car.jpg"),filename: "car.jpg")
    },
    {
      email:          "sato65_63@examle.com",
      name:           "卵焼き",
      unique_id:      "atuyaki",
      password:       "password1",
      date_of_birth:  "2000-12-30",
      introduction:   "趣味は音ゲーとソシャゲ",
      private_status: true,
      is_deleted:     false,
      profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("app/assets/images/no_image.jpg"), filename: "no_image.jpg")
    }
  ]
)

post1 = Post.create!(
  end_user_id:  1,
  body: "愛犬に見守られながら作業中。。。"
)

post2 = Post.create!(
  end_user_id:  5,
  body: "今の俺"
)

posts = Post.create!(
  [
    {
      end_user_id:  2,
      body: "先日からキーボードの調子悪いからセールで買ったんだけど、予想より打鍵感が好み。いい買い物した！",
      post_images: [ActiveStorage::Blob.create_and_upload!(io: File.open("db/images/post/kyeboard.jpg"), filename: "kyeboard.jpg")]
    },
    {
      end_user_id:  3,
      body: "すみません。こちらのエラーの解決方法がわかる方いますか？",
      post_images: [ActiveStorage::Blob.create_and_upload!(io: File.open("db/images/post/error.png"), filename: "error.png")]
    },
    {
      end_user_id:  5,
      body: "2年前の自分に背中から刺されてる"
    },
    {
      end_user_id:  1,
      body: "もくもく会に興味があるんだけどどこで募集しているんだろう？"
    }
  ]
)

post1.post_images.attach(io: File.open(Rails.root.join("db/images/post/dog.jpg")), filename: "dog.jpg")
post1.post_images.attach(io: File.open(Rails.root.join("db/images/post/flower.jpg")), filename: "flower.jpg")

post2.post_images.attach(io: File.open(Rails.root.join("db/images/post/program.jpg")), filename: "program.jpg")
post2.post_images.attach(io: File.open(Rails.root.join("db/images/post/OhMyGod.jpg")), filename: "OhMyGod.jpg")

PostComment.create!(
  [
    {
      post_id: 4,
      end_user_id: 2,
      body: "こんにちは！エラー文で「Did you mean?　unique_id= 」と聞かれているのでunipue_idのスペルミスの可能性が高いですね！確認してみて下さい！"
    },
    {
      post_id: 4,
      end_user_id: 3,
      body: "ありがとうございます！jonnさんが仰った通り、unique_idのスペルミスでした。これからはしっかりエラー文を読み込もうと思います。"
    },
    {
      post_id: 6,
      end_user_id: 4,
      body: "昔、自分がもくもく会を開いたときはconnpassで募集しましたよ"
    }
  ]
)

Relationship.create!(
  [
    {
      follower_id: EndUser.find(1).id,
      followed_id: EndUser.find(2).id
    },
    {
      follower_id: EndUser.find(3).id,
      followed_id: EndUser.find(2).id
    },
    {
      follower_id: EndUser.find(2).id,
      followed_id: EndUser.find(1).id
    },
    {
      follower_id: EndUser.find(4).id,
      followed_id: EndUser.find(5).id
    },
    {
      follower_id: EndUser.find(5).id,
      followed_id: EndUser.find(4).id
    }
  ]
)

Like.create!(
  [
    {
      end_user_id: 3,
      post_id: 1
    },
    {
      end_user_id: 2,
      post_id: 1
    },
    {
      end_user_id: 2,
      post_id: 5
    },
    {
      end_user_id: 4,
      post_id: 3
    },
    {
      end_user_id: 4,
      post_id: 2
    },
    {
      end_user_id: 1,
      post_id: 5
    },
  ]
)


Admin.create!(
  email: "admin@example.com",
  login: "admin",
  password: "password"
)

