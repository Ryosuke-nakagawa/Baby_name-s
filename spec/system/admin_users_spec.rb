require 'rails_helper'

RSpec.describe "AdminUsers", type: :system do
  
  let(:admin_user) { create(:user, :admin) }
  let!(:another_user) { create(:user, :general) }
  before do
    # session[:user_id]に値を入れユーザーがログインしている状態を作る
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: admin_user.id)
  end

  describe '管理画面:ユーザ一覧ページ' do
    context '正常系' do
      it 'ユーザーページにアクセスした場合、全てのユーザーが表示されること' do
        visit admin_users_path
        expect(page).to have_content(admin_user.name)
        expect(page).to have_content(admin_user.group_id)
        expect(page).to have_content(admin_user.role)
        expect(page).to have_content(another_user.name)
        expect(page).to have_content(another_user.group_id)
        expect(page).to have_content(another_user.role)
        expect(current_path).to eq admin_users_path
      end
      it '一覧ページで「Show」をクリックすると、ユーザー詳細が表示されること' do
        visit admin_users_path
        page.all('.btn-info')[0].click
        expect(page).to have_content(another_user.name)
        expect(page).to have_content(another_user.group_id)
        expect(page).to have_content(another_user.line_id)
        expect(page).to have_content(another_user.uuid)
        expect(current_path).to eq admin_user_path(another_user)
      end
      it '一覧ページで「Delete」をクリックすると、ユーザーが削除されること' do
        visit admin_users_path
        page.accept_confirm do
          page.all('.btn-danger')[0].click
        end
        expect(page).not_to have_content(another_user.name)
        expect(User.count).to eq 1
        expect(current_path).to eq admin_users_path
      end
      it '一覧ページで「Edit」をクリックすると、ユーザー編集画面に遷移する' do
        visit admin_users_path
        page.all('.btn-success')[0].click
        expect(current_path).to eq edit_admin_user_path(another_user)
      end
    end
    context '異常系' do
      it 'adminユーザーではないユーザーはユーザー一覧の管理画面に遷移できない' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: another_user.id)
        visit admin_users_path
        expect(page).not_to have_content(admin_user.name)
        expect(page).not_to have_content(admin_user.role)
        expect(page).to have_content('権限がありません')
        expect(current_path).to eq root_path
      end
    end
  end
  describe '管理画面: ユーザー詳細' do
    context '正常系' do
      it '「Edit」ボタンで編集画面に遷移できる' do
        visit admin_user_path(another_user)
        click_link 'Edit'
        expect(current_path).to eq edit_admin_user_path(another_user)
      end
      it '「Delete」ボタンでユーザーを削除できる' do
        visit admin_user_path(another_user)
        page.accept_confirm do
          click_link 'Delete'
        end
        expect(page).not_to have_content(another_user.name)
        expect(page).not_to have_content(another_user.role)
        expect(User.count).to eq 1
        expect(current_path).to eq admin_users_path
      end
    end
  end
  describe '管理画面: ユーザー編集' do
    context '正常系' do
      it '他ユーザーの編集ができる' do
        visit edit_admin_user_path(another_user)
        fill_in 'Name', with: 'edit_name'
        select 'admin', from: 'Role'
        click_on '更新する'
        visit admin_user_path(another_user)
        expect(page).to have_content('edit_name')
        expect(page).to have_content('admin')
      end
    end
  end
end
