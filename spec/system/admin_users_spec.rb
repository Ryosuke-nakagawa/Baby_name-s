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
      end
      it '一覧ページで「Edit」をクリックすると、ユーザー編集画面に遷移する' do
      end
    end
    context '異常系' do
      it 'adminユーザーではないユーザーはユーザー一覧の管理画面に遷移できない' do
      end
    end
  end
  describe '管理画面: ユーザー詳細' do
    context '正常系' do
      it '「Edit」ボタンで編集画面に遷移できる' do
      end
      it '「Delete」ボタンでユーザーを削除できる' do
      end
    end
  end
  describe '管理画面: ユーザー編集' do
    context '正常系' do
      it '他ユーザーの編集ができる' do
      end
    end
  end
end
