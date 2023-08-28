require 'rails_helper'

RSpec.describe EndUser, type: :model do
  describe 'ユーザーのテスト' do
    let!(:end_user) {
      create(
        name: "結月ゆかり",
        unique_id: "yukari",
        email: "yukarisan@vocaloid.com",
        password: "password1"
      )
    }
    describe '新規登録のテスト' do
      before do
        visit new_end_user_session_path
      end
      context '新規登録の'
    end
  end
  it "名前、ユーザーID 、メールアドレス、パスワードがあれば有効な状態であること" do
    end_user = EndUser.new(
      name: "結月ゆかり",
      unique_id: "yukari",
      email: "yukarisan@vocaloid.com",
      password: "password1"
    )
    expect(end_user).to be_valid
  end
  it "名前が無ければ無効な状態であるこ" do
    end_user = EndUser.new(name: nil)
    end_user.valid?
    expect(end_user.errors[:name]).to include("を入力してください")
  end
  it "ユーザーID が無ければ無効な状態であるこ" do
    end_user = EndUser.new(unique_id: nil)
    end_user.valid?
    expect(end_user.errors[:unique_id]).to include("を入力してください")
  end
  it "メールアドレスが無ければ無効な状態であること" do
    end_user = EndUser.new(email: nil)
    end_user.valid?
    expect(end_user.errors[:email]).to include("を入力してください")
  end
  it "パスワードが無ければ無効な状態であるこ" do
    end_user = EndUser.new(password: nil)
    end_user.valid?
    expect(end_user.errors[:password]).to include("を入力してください")
  end
  it "重複したメールアドレスなら無効な状態であること" do
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
  it "@が無いメールアドレスなら無効な状態であること" do
    end_user = EndUser.new(
      name: "結月ゆかり",
      unique_id: "yukari",
      email: "yukarisan_vocaloid.com",
      password: "password1"
    )
    end_user.valid?
    expect(end_user.errors[:email]).to include("は不正な値です")
  end
  it "重複したユーザーID なら無効な状態であること" do
    EndUser.create(
      name: "結月ゆかり",
      unique_id: "yukari",
      email: "yukarisan@vocaloid.com",
      password: "password1"
    )
    end_user = EndUser.new(
      name: "結月ゆかりん",
      unique_id: "yukari",
      email: "yukarisan-2@vocaloid.com",
      password: "password1"
    )
    end_user.valid?
    expect(end_user.errors[:unique_id]).to include("はすでに存在します")
  end
  it "英数字、アンダースコア、句読を含んでいないユーザーID なら無効な状態であること" do
    end_user = EndUser.new(
      name: "結月ゆかり",
      unique_id: "ゆかり",
      email: "yukarisan_vocaloid.com",
      password: "password1"
    )
    end_user.valid?
    expect(end_user.errors[:unique_id]).to include("は英数字、アンダースコア、句読点のみ使用できます")
  end
  it "英数字を含んでいないパスワードなら無効な状態であること" do
    end_user = EndUser.new(
      name: "結月ゆかり",
      unique_id: "ゆかり",
      email: "yukarisan_vocaloid.com",
      password: "password"
    )
    end_user.valid?
    expect(end_user.errors[:password]).to include("は半角英数を両方含む必要があります")
  end
  
  
  
end
