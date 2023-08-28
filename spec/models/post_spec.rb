require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '投稿テスト' do
    context '新規投稿テスト' do
      context '有効な状態' do
        it "テキストだけで投稿できる状態であること" do
          post = FactoryBot.build(:post, :more_than_500_words)
          expect(post).to be_valid
        end
          context '画像' do
          it " imageとテキストで投稿できるbe in a state" do
            post = FactoryBot.build(:post)
            post.post_images = fixture_file_upload("images/rejoice_man_mono.png")
            expect(post).to be_valid
          end
        end
      end
      context '無効な状態' do
        it 'テキストが2文字以下の場合は無効な状態であること'
        it 'テキストが500文字以上の場合は無効な状態であること'
        it '画像が3MB以上の場合無効な状態であること'
        it '画像が4つ以上の場合無効な状態であること'
        it '画像がjpeg,png以外の場合無効な状態であること'
      end
    end
  end
end
