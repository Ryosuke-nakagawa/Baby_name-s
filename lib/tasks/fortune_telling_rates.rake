namespace :fortune_telling_rates do
  desc '姓名判断の結果を再取得'
  task get_rates: :environment do
    all_first_names = FirstName.all
    all_first_names.each do |first_name|
      fortune_telling = FortuneTelling.new(first_name: first_name.name, last_name: first_name.group.last_name)

      result = fortune_telling.rates
      first_name.update(fortune_telling_url: fortune_telling.search_url,
                        fortune_telling_rate: result[:rate], fortune_telling_heaven: result[:heaven], fortune_telling_person: result[:person], fortune_telling_land: result[:land], fortune_telling_outside: result[:outside], fortune_telling_all: result[:all], fortune_telling_talent: result[:talent])
    end
  end
end
