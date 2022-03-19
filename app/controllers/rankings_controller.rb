class RankingsController < ApplicationController
  def index
    @group = current_user.group
    @selected_year = params[:year] || Ranking.maximum(:year)
    years = Ranking.select(:year).group(:year).order(year: :desc)
    @saved_years = years.pluck('year')

    boy_first_names = Ranking.where(year: @selected_year, sex: 'boy')
    girl_first_names = Ranking.where(year: @selected_year, sex: 'girl')
    @ranking_first_names = [boy_first_names, girl_first_names].transpose
  end
end
