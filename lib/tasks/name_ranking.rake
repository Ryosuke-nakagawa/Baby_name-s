require 'open-uri'


namespace :name_ranking do
  desc '「たまひよ」から名前ランキングを取得'
  task :get, ['year'] => :environment do |task,args|

    boys_search_url = "https://st.benesse.ne.jp/ninshin/name/#{args[:year]}/boy/name-ranking/"
    girls_search_url = "https://st.benesse.ne.jp/ninshin/name/#{args[:year]}/girl/name-ranking/"

    search_urls = [boys_search_url, girls_search_url]

    search_urls.each.with_index(1) do |search_url, sex_num|
      html = URI.open(search_url).read
      doc = Nokogiri::HTML.parse(html)

      nums = doc.css('.tbl_ranking_num')
      names =doc.css('.tbl_ranking_name')
      kanas =doc.css('.tbl_ranking_kana')
      result = [nums, names, kanas].transpose

      result.each.with_index(1) do |result, index|
        ranking = Ranking.new(year: args[:year].to_i, sex: sex_num, rank: result[0].text.to_i, name: result[1].text, reading: result[2].text)
        ranking.save
        break if index == 40
      end
    end
  end
end
