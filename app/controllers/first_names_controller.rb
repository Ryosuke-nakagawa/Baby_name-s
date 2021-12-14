class FirstNamesController < ApplicationController
  before_action :set_first_names_liffid, only: [:login]

  require 'net/http'
  require 'uri'

  def login
    if params[:idToken]
      idToken = params[:idToken]
      channelId = ENV['LIFF_CHANNEL_ID']
      res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),{'id_token'=>idToken, 'client_id'=>channelId})
      line_user_id = JSON.parse(res.body)["sub"]
      user = User.find_by(line_id: line_user_id)

      session[:user_id] = user.id
      group_id = { id: user.group_id }
      render json: group_id
    end
  end

  def index
    @user = User.find(session[:user_id])
    @first_names = @user.group.first_names
  end

  def update
  end

  def destroy
  end

  def show
    @first_name = FirstName.find(params[:id])
    @group = Group.find(params[:group_id])
  end
end
