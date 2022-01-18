class UsersController < ApplicationController
  before_action :set_login_liffid, only: %i[new]
  skip_before_action :login_required, only: %i[new create]

  require 'net/http'
  require 'uri'

  def new; end

  def create
    id_token = params[:idToken]
    channel_id = ENV['LIFF_CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),
                              { 'id_token' => id_token, 'client_id' => channel_id })
    line_user_id = JSON.parse(res.body)['sub']
    user = User.find_by(line_id: line_user_id)
    if params[:uuid] # 人からの紹介urlの場合
      link_user = User.find_by(uuid: params[:uuid])
      user = User.create!(line_id: line_user_id, group: link_user.group)
      session[:user_id] = user.id
      return
    end
    if user.nil?
      group = Group.create!
      user = User.create!(line_id: line_user_id, group: group)
    end
    session[:user_id] = user.id
  end
end
