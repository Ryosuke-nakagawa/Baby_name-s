class UsersController < ApplicationController
  before_action :set_login_liff_id, only: [:login]

  require 'net/http'
  require 'uri'
  
  def login
  end
  def new
    
  end
  
  def create
    idToken = params[:idToken]
    channelId = ENV['LIFF_CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),{'id_token'=>idToken, 'client_id'=>channelId})
    line_user_id = JSON.parse(res.body)["sub"]
    user = User.find_by(line_id: line_user_id)

    if params[:uuid]
      link_user = user.find_by(uuid: params[:uuid])
      user = User.create!(line_id: line_user_id, group: link_user.group_id)
      return
    end

    if user.nil?
        group = Group.create!
        user = User.create!(line_id: line_user_id, group: group)
        session[:user_id] = user.id
    else
        session[:user_id] = user.id
        uuid = { id: user.line_id }
        render json: uuid
    end
  end

end
