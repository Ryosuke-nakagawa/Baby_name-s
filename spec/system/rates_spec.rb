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
        fortune_telling_rate = all('.star-index')[2]
        expect(sound_rate['data-rate']).to eq rate.sound_rate.to_f.to_s
        expect(character_rate['data-rate']).to eq rate.character_rate.to_f.to_s
        expect(fortune_telling_rate['data-rate']).to eq first_name.fortune_telling_rate.to_f.to_s
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
        fortune_telling_rate = all('.star-show')[2]
        expect(sound_rate['data-rate']).to eq rate.sound_rate.to_f.to_s
        expect(character_rate['data-rate']).to eq rate.character_rate.to_f.to_s
        expect(fortune_telling_rate['data-rate']).to eq first_name.fortune_telling_rate.to_f.to_s
        expect(Rate.count).to eq 1
        expect(current_path).to eq first_name_path(first_name)
      end
    end
  end
  describe '評価の編集' do
    context '正常系' do
      it '「音の響き」の評価が変更されること', js: true do
        visit first_name_path(first_name)
        page.first("#js-edit-rate").click
        find("img[alt='2']").click
        page.first("#js-update-rate").click
        sleep 1
        sound_rate = all('.star-show')[0]
        expect(sound_rate['data-rate']).to eq '2.0'
        expect(current_path).to eq first_name_path(first_name)
      end
      it '「漢字」の評価が変更されること', js: true do
        visit first_name_path(first_name)
        edit = page.all("#js-edit-rate")[1]
        edit.click
        find("img[alt='3']").click
        update = page.all("#js-update-rate")[0]
        update.click
        sleep 1
        sound_rate = all('.star-show')[1]
        expect(sound_rate['data-rate']).to eq '3.0'
        expect(current_path).to eq first_name_path(first_name)
      end
    end
  end
end
