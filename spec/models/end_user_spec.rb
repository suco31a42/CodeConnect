require 'rails_helper'

RSpec.describe EndUser, type: :model do
  # 名前、ユーザーID 、メールアドレス、パスワードがあれば有効な状態であること
  it "is valid wirh a name, unique_id, email, and password" do
    end_user = EndUser.new(
      name: "結月ゆかり",
      unique_id: "yukari",
      email: "yukarisan@vocaloid.com",
      password: "password1"
    )
    expect(end_user).to be_valid
  end
  # 名前がなければ無効な状態であること
  it "is invalid without a name" do
    end_user = EndUser.new(name: nil)
    end_user.valid?
    expect(end_user.errors[:name]).to include("を入力してください")
  end
  # ユーザーID が無ければ無効な状態であること
  it "is invalid without a unique_id" do
    end_user = EndUser.new(unique_id: nil)
    end_user.valid?
    expect(end_user.errors[:unique_id]).to include("を入力してください")
  end
  # メールアドレスが無ければ無効な状態であること
  it "is invalid without a email" do
    end_user = EndUser.new(email: nil)
    end_user.valid?
    expect(end_user.errors[:email]).to include("を入力してください")
  end
  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a dupllicate email address" do
    EndUser.create(
      name: "結月ゆかり",
      unique_id: "yukari",
      email: "yukarisan@vocaloid.com",
      password: "password1"
    )
    end_user = EndUser.new(
      name: "結月ゆかりん",
      unique_id: "yukarinn",
      email: "yukarisan@vocaloid.com",
      password: "password1"
    )
    end_user.valid?
    expect(end_user.errors[:email]).to include("はすでに存在します")
  end
  # 重複したユーザーID なら無効な状態であること
  it "is invalid with a dupllicate unique_id"
end
