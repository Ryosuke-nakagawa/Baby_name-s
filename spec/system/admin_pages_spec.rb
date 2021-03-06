require 'rails_helper'

RSpec.describe "AdminPages", type: :system do
  let(:admin_user) { create(:user, :admin) }
  let!(:another_user) { create(:user, :general) }
  before do
    # session[:user_id]に値を入れユーザーがログインしている状態を作る
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: admin_user.id)
  end

  describe '管理画面' do
    context '正常系' do
      it 'adminユーザーは管理画面のダッシュボードページに遷移できる' do
        visit admin_root_path
        expect(page).to have_content('DashBoard')
        expect(current_path).to eq admin_root_path
      end
      it 'ログアウトボタンで管理画面からトップページに遷移する' do
        visit admin_root_path
        page.accept_confirm do
          click_link 'Logout'
        end
        expect(page).to have_content('ログアウトしました') 
        expect(current_path).to eq root_path 
      end
    end
    context '異常系' do
      it 'adminユーザーではないユーザーは管理画面に遷移できない' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: another_user.id)
        visit admin_root_path
        expect(page).to have_content('権限がありません')
        expect(current_path).to eq root_path
      end
    end
  end
end
