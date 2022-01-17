namespace :name_ranking do
  desc '「たまひよ」から名前ランキングを取得'
  task :get, ['year'] => :environment do |task,args|
    year = args[:year]
    p year
  end
end
