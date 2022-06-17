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
  describe 'コメントの編集・削除' do
    context 'コメントしたユーザー' do
      let!(:comment) { create(:comment, first_name: first_name, user: user) }
      context 'フォームの入力値が正常' do
        it 'コメント編集が成功する' do
          visit first_name_path(first_name)
          find('.js-edit-comment-button').click

          fill_in "js-textarea-comment-#{comment.id}", with: 'edit_comment'
          click_button '更新'
          expect(page).to have_content 'edit_comment'
          expect(current_path).to eq first_name_path(first_name)
        end
      end
      context 'コメントが空欄' do
        it 'コメント編集が失敗する' do
          visit first_name_path(first_name)
          find('.js-edit-comment-button').click

          fill_in "js-textarea-comment-#{comment.id}", with: ''
          click_button '更新'
          expect(page).to have_content 'コメントを入力してください'
          expect(current_path).to eq first_name_path(first_name)
        end
      end
      it 'コメント削除に成功する' do
        visit first_name_path(first_name)
        find('.js-delete-comment-button').click
        expect{
        expect(page.accept_confirm).to eq "削除しますか?"
        expect(page).to have_content "コメントを削除しました"
        }. to change(Comment.all, :count).by(-1)
        expect(current_path).to eq first_name_path(first_name)
      end
    end
    context 'コメントしたユーザー以外' do
      let!(:another_user) { create(:user, group: user.group) }
      let!(:another_users_comment) { create(:comment, first_name: first_name, user: another_user) }
      it '編集・削除ボタンが表示されない' do
        visit first_name_path(first_name)
        expect(page).to have_content another_users_comment.body
        expect(page).to have_no_css 'js-edit-comment-button'
        expect(page).to have_no_css 'js-delete-comment-button'
      end
    end
  end
end
