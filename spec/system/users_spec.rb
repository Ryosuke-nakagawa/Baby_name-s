require 'rails_helper'

RSpec.describe "Users", type: :system do

  let!(:real_user) { create(:user, :real_account) }
  let!(:first_name) { create(:first_name, group: real_user.group) }
  let!(:rate) { create(:rate, user: real_user, first_name: first_name) }
  before do
    # session[:user_id]に値を入れユーザーがログインしている状態を作る
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: real_user.id)
  end

  describe 'ユーザー設定画面' do
    context '正常系' do
      it 'ユーザー設定を変更した場合、反映されること' do
        visit new_group_path
        fill_in '上の名前を入力してください', with: 'test'
        all('label.btn')[0].click
        all('label.btn')[3].click
        all('label.btn')[6].click
        click_button '決定'
        expect(page).to have_content('ユーザーを更新しました')
      end
    end
  end
end
