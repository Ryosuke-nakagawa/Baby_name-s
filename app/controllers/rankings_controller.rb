class RankingsController < ApplicationController

  def index
    if params[:year]
      @selected_year = params[:year]
    else
      @selected_year = Ranking.maximum(:year)
    end
    years = Ranking.select(:year).group(:year).order(year: :desc)
    @saved_years= []
    years.each do |year|
      @saved_years << year[:year]
    end
    boy_first_names = Ranking.where(year: @selected_year,sex: "boy")
    girl_first_names = Ranking.where(year: @selected_year,sex: "girl")
    @ranking_first_names = [boy_first_names, girl_first_names].transpose
  end
end
