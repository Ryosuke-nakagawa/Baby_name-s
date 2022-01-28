require 'rails_helper'

RSpec.describe "Rates", type: :system do

  let!(:user) { create(:user) }
  let!(:first_name) { create(:first_name, group: user.group) }
  let!(:rate) { create(:rate, user: user, first_name: first_name) }
  before do
    # session[:user_id]に値を入れユーザーがログインしている状態を作る
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
  end

  describe '名前一覧画面' do
    context '正常系' do
      it '一覧ページにアクセスした場合、評価が表示されること' do
        visit group_first_names_path(user.group)
        sound_rate = all('.star-index')[0]
        character_rate = all('.star-index')[1]
        fotune_telling_rate = all('.star-index')[2]
        expect(sound_rate['data-rate']).to eq rate.sound_rate.to_f.to_s
        expect(character_rate['data-rate']).to eq rate.character_rate.to_f.to_s
        expect(fotune_telling_rate['data-rate']).to eq first_name.fotune_telling_rate.to_f.to_s
        expect(Rate.count).to eq 1
        expect(current_path).to eq group_first_names_path(user.group)
      end
    end
  end
  describe '名前詳細' do
    context '正常系' do
      it '評価が表示されること' do
        visit first_name_path(first_name)
        sound_rate = all('.star-show')[0]
        character_rate = all('.star-show')[1]
        fotune_telling_rate = all('.star-show')[2]
        expect(sound_rate['data-rate']).to eq rate.sound_rate.to_f.to_s
        expect(character_rate['data-rate']).to eq rate.character_rate.to_f.to_s
        expect(fotune_telling_rate['data-rate']).to eq first_name.fotune_telling_rate.to_f.to_s
        expect(Rate.count).to eq 1
        expect(current_path).to eq first_name_path(first_name)
      end
    end
  end
  describe '評価の編集' do
    context '正常系' do
      it '評価が変更されること' do
        visit edit_first_name_rate_path(first_name,rate)
        all('label.btn')[0].click
        all('label.btn')[9].click
        click_button '決定'
        sound_rate = all('.star-show')[0]
        character_rate = all('.star-show')[1]
        expect(sound_rate['data-rate']).to eq '1.0'
        expect(character_rate['data-rate']).to eq '5.0'
        expect(page).to have_content('評価を更新しました')
        expect(current_path).to eq first_name_path(first_name)
      end
    end
  end
end
