require 'rails_helper'

RSpec.describe EndUser, type: :model do
  describe 'ユーザーのテスト' do
    context '新規登録テスト' do
      it "名前、ユーザーID 、メールアドレス、パスワードがあれば有効な状態であること" do
        end_user = FactoryBot.build(:end_user)
        expect(end_user).to be_valid
      end
      it "名前が無ければ無効な状態であるこ" do
        end_user = FactoryBot.build(:end_user, name: nil)
        end_user.valid?
        expect(end_user.errors[:name]).to include("を入力してください")
      end
      it "ユーザーID が無ければ無効な状態であるこ" do
        end_user = FactoryBot.build(:end_user,unique_id: nil)
        end_user.valid?
        expect(end_user.errors[:unique_id]).to include("を入力してください")
      end
      it "メールアドレスが無ければ無効な状態であること" do
        end_user = FactoryBot.build(:end_user,email: nil)
        end_user.valid?
        expect(end_user.errors[:email]).to include("を入力してください")
      end
      it "パスワードが無ければ無効な状態であるこ" do
        end_user = FactoryBot.build(:end_user,password: nil)
        end_user.valid?
        expect(end_user.errors[:password]).to include("を入力してください")
      end
      it "重複したメールアドレスなら無効な状態であること" do
        FactoryBot.create(:end_user, email: "akarin@exaple.com")
        end_user = FactoryBot.build(:end_user, email: "akarin@exaple.com")
        end_user.valid?
        expect(end_user.errors[:email]).to include("はすでに存在します")
      end
      it "@が無いメールアドレスなら無効な状態であること" do
        end_user = FactoryBot.build(:end_user, email: "akarin_exaple.com")
        end_user.valid?
        expect(end_user.errors[:email]).to include("は不正な値です")
      end
      it "重複したユーザーID なら無効な状態であること" do
        FactoryBot.create(:end_user, unique_id: "yukari")
        end_user = FactoryBot.build(:end_user, unique_id: "yukari")
        end_user.valid?
        expect(end_user.errors[:unique_id]).to include("はすでに存在します")
      end
      it "英数字、アンダースコア、句読を含んでいないユーザーID なら無効な状態であること" do
        end_user = FactoryBot.build(:end_user, unique_id: "あかり")
        end_user.valid?
        expect(end_user.errors[:unique_id]).to include("は英数字、アンダースコア、句読点のみ使用できます")
      end
      it "英数字を含んでいないパスワードなら無効な状態であること" do
        end_user = FactoryBot.build(:end_user, password: "123456")
        end_user.valid?
        expect(end_user.errors[:password]).to include("は半角英数を両方含む必要があります")
      end
    end
  end
end
