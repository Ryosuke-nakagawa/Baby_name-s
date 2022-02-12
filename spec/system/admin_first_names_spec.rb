require 'rails_helper'

RSpec.describe "AdminFirstNames", type: :system do

  let(:admin_user) { create(:user, :admin) }
  let!(:another_user) { create(:user, :general) }
  let!(:first_name) { create(:first_name, group: another_user.group) }
  before do
    # session[:user_id]に値を入れユーザーがログインしている状態を作る
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: admin_user.id)
  end

  describe '管理画面:名前一覧ページ' do
    context '正常系' do
      it '名前一覧ページにアクセスした場合、自分以外のユーザーの作成した名前も表示されること' do
        visit admin_first_names_path
        expect(page).to have_content(first_name.name)
        expect(page).to have_content(first_name.reading)
        expect(current_path).to eq admin_first_names_path
      end
      it '一覧ページで「Show」をクリックすると、名前が表示れること' do
        visit admin_first_names_path
        click_link 'Show'
        expect(page).to have_content(first_name.name)
        expect(page).to have_content(first_name.reading)
        expect(current_path).to eq admin_first_name_path(first_name)
      end
      it '一覧ページで「Delete」をクリックすると、名前が削除されること' do
        visit admin_first_names_path
        page.accept_confirm do
          click_link 'Delete'
        end
        expect(page).not_to have_content(first_name.name)
        expect(page).not_to have_content(first_name.reading)
        expect(FirstName.count).to eq 0
        expect(current_path).to eq admin_first_names_path
      end
      it '一覧ページで「Edit」をクリックすると、編集画面に遷移する' do
        visit admin_first_names_path
        click_link 'Edit'
        expect(current_path).to eq edit_admin_first_name_path(first_name)
      end
    end
    context '異常系' do
      it 'adminユーザーではないユーザーは名前一覧の管理画面に遷移できない' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: another_user.id)
        visit admin_first_names_path
        expect(page).not_to have_content(first_name.name)
        expect(page).not_to have_content(first_name.reading)
        expect(page).to have_content('権限がありません')
        expect(current_path).to eq root_path
      end
    end
  end
  describe '管理画面: 名前詳細' do
    context '正常系' do
      it '「Edit」ボタンで編集画面に遷移できる' do
        visit admin_first_name_path(first_name)
        click_link 'Edit'
        expect(current_path).to eq edit_admin_first_name_path(first_name)
      end
      it '「Delete」ボタンで名前を削除できる' do
        visit admin_first_name_path(first_name)
        page.accept_confirm do
          click_link 'Delete'
        end
        expect(page).not_to have_content(first_name.name)
        expect(page).not_to have_content(first_name.reading)
        expect(FirstName.count).to eq 0
        expect(current_path).to eq admin_first_names_path
      end
    end
  end
  describe '管理画面: 名前編集' do
    context '正常系' do
      it '他ユーザーの作成した名前の編集ができる' do
        visit edit_admin_first_name_path(first_name)
        fill_in 'Name', with: 'edit_name'
        fill_in 'Reading', with: 'edit_reading'
        click_on '更新する'
        expect(page).to have_content('edit_name')
        expect(page).to have_content('edit_reading')
        expect(current_path).to eq admin_first_names_path
      end
    end
  end
end