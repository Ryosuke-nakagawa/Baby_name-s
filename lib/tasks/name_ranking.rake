require 'open-uri'


namespace :name_ranking do
  desc '「赤ちゃん名づけ」から名前ランキングを取得'
  task :get, ['year'] => :environment do |task,args|
    article_number = args[:year].to_i - 2013
    search_url = "https://namae-yurai.net/oneYearNamaeTrendBoysGirls.htm?rankingId=#{article_number}"

    html = URI.open(search_url).read
    doc = Nokogiri::HTML.parse(html)

    ranking = doc.at_css('#ranking')
    tbody = ranking.css('tbody')

    tbody.css('td').each_slice(5).with_index(1) do |result, index|
      boy_read = result[2].text.sub(/ など/, '')
      girl_read = result[4].text.sub(/ など/, '')
      Ranking.create!(year: args[:year].to_i, sex: 1, rank: index, name: result[1].text, reading: boy_read)
      Ranking.create!(year: args[:year].to_i, sex: 2, rank: index, name: result[3].text, reading: girl_read)
    end
  end
end
