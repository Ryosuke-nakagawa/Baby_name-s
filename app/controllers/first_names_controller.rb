class FirstNamesController < ApplicationController
  before_action :set_first_names_liffid, only: [:new]
  skip_before_action :login_required, only: [:new, :login]

  require 'net/http'
  require 'uri'

  def new
  end

  def login
    idToken = params[:idToken]
    channelId = ENV['LIFF_CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),{'id_token'=>idToken, 'client_id'=>channelId})
    line_user_id = JSON.parse(res.body)["sub"]
    user = User.find_by(line_id: line_user_id)

    session[:user_id] = user.id
    group_id = { id: user.group_id }
    render json: group_id
  end

  def index
    @group = Group.find(params[:group_id])
    @sort = params[:sort]
    case params[:sort]
    when 'sound'
      @first_names = []
      result = FirstName.where(group_id: @group.id).joins(:rates).group(:id).order('average_rates_sound_rate DESC').average("rates.sound_rate")
      result.map{ |first_name_id, average| @first_names << FirstName.find(first_name_id) }
    when 'character'
      @first_names = []
      result = FirstName.where(group_id: @group.id).joins(:rates).group(:id).order('average_rates_character_rate DESC').average("rates.character_rate")
      result.map{ |first_name_id, average| @first_names << FirstName.find(first_name_id) }
    when 'fotune_telling'
      @first_names = FirstName.where(group_id: @group.id).order(fotune_telling_rate: :DESC)
    else
      @first_names = FirstName.sort_by_overall_rating(@group.first_names,@group.users)
    end
  end

  def destroy
    @first_name = FirstName.find(params[:id])
    @first_name.destroy
    redirect_to  group_first_names_path(@first_name.group)
  end

  def show
    @first_name = FirstName.find(params[:id])
    @group = Group.find(@first_name.group_id)
    @rate = Rate.find_by(user: current_user, first_name: @first_name)
    @rates = Rate.ratings_within_group(@first_name,@group)
  end
end
