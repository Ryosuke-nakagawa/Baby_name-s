require 'rails_helper'

RSpec.describe "Comments", type: :system do

  let!(:user) { create(:user) }
  let!(:first_name) { create(:first_name, group: user.group) }
  let!(:rate) { create(:rate, user: user, first_name: first_name) }
  
  before do
    # session[:user_id]に値を入れユーザーがログインしている状態を作る
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
  end

  describe 'コメント登録' do
    context 'フォームの入力値が正常' do
      it 'コメント登録が成功する' do
        visit first_name_path(first_name)
        fill_in 'js-new-comment-body', with: 'test_comment'
        click_button 'コメントする'
        expect(page).to have_content 'test_comment'
        expect(current_path).to eq first_name_path(first_name)
      end
    end
    context 'コメントが未入力' do
      it 'コメント登録が失敗する' do
        visit first_name_path(first_name)
        click_button 'コメントする'
        expect(page).to have_content 'コメントを入力してください'
        expect(current_path).to eq first_name_path(first_name)
      end
    end
  end
  describe 'コメントの編集' do
    context 'コメントしたユーザー' do
      context 'フォームの入力値が正常' do
        it 'コメント編集が成功する' do
        end
      end
      context 'コメントが空欄' do
        it 'コメント編集が失敗する' do
        end
      end
    end
    context 'コメントしたユーザー以外' do
      it '編集ボタンが表示されない' do
      end
    end
  end
  describe 'コメントの削除' do
    context 'コメントしたユーザー' do
      it '削除が成功する' do
      end
    end
    context 'コメントしたユーザー以外' do
      it '削除ボタンが表示されない' do
      end
    end
  end
end
