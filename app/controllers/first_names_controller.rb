class FirstNamesController < ApplicationController
  before_action :set_first_names_liffid, only: [:new]

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
    @user = User.find(session[:user_id])
    @first_names = @user.group.first_names
  end

  def destroy
    @first_name = FirstName.find(params[:id])
    @first_name.destroy
    redirect_to  group_first_names_path(@first_name.group)
  end

  def show
    @first_name = FirstName.find(params[:id])
    @group = Group.find(params[:group_id])
  end

  def edit
    @user = User.find(session[:user_id])
    @first_name = FirstName.find(params[:id])
    @group = Group.find(params[:group_id])
    @rate = Rate.find_by(user: @user,first_name: @first_name)
    if @rate.nil?
      @rate = Rate.new
    end 
  end

end
