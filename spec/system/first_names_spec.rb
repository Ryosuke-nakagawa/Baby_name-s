require 'rails_helper'

RSpec.describe "FirstNames", type: :system do
  let!(:user) { create(:user) }
  let!(:first_name) { create(:first_name, group: user.group) }
  before do
    # session[:user_id]に値を入れユーザーがログインしている状態を作る
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
  end

  describe '名前一覧画面' do
    context '正常系' do
      it '一覧ページにアクセスした場合、名前が表示されること' do
        visit group_first_names_path(user.group)
        expect(page).to have_content(first_name.name)
        expect(page).to have_content(first_name.reading)
        expect(FirstName.count).to eq 1
        expect(current_path).to eq group_first_names_path(user.group)
      end
    end
  end
  describe '名前新規作成' do
    context '正常系' do
      it '名前が新規作成されること' do
      end
    end
  end
  describe '名前詳細' do
    context '正常系' do
      it '名前が表示されること' do
      end
    end
  end
  describe '名前削除' do
    context '正常系' do
      it '名前が削除されること' do
      end
    end
  end
end
