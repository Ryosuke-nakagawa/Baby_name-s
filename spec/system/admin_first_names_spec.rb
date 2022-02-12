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
        expect(FirstName.count).to eq 1
        expect(current_path).to eq admin_first_names_path
      end
      it '一覧ページで「show」をクリックすると、名前が表示されること' do
        visit admin_first_names_path
        click_link 'Show'
        expect(page).to have_content(first_name.name)
        expect(page).to have_content(first_name.reading)
        expect(current_path).to eq admin_first_name_path(first_name)
      end
      it '一覧ページで「delete」をクリックすると、名前が削除されること' do
      end
      it '一覧ページで「edit」をクリックすると、編集画面に遷移する' do
      end
    end
    context '異常系' do
      it 'adminユーザーではないユーザーは名前一覧の管理画面に遷移できない' do
      end
    end
  end
  describe '管理画面: 名前詳細' do
    context '正常系' do
      it '「edit」ボタンで編集画面に遷移できる' do
      end
      it '「delete」ボタンで名前を削除できる' do
      end
    end
  end
  describe '管理画面: 名前編集' do
    context '正常系' do
      it '他ユーザーの作成した名前の編集ができる' do
      end
    end
  end
end