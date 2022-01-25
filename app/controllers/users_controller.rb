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
      if user.nil?
        user = User.create!(line_id: line_user_id, group: link_user.group)
      else
        user.update!(group: link_user.group)
      end
    end
    if user.nil?
      group = Group.create!
      user = User.create!(line_id: line_user_id, group: group)
    end
    session[:user_id] = user.id
  end

  def destroy
    user = User.find(session[:user_id])
    leave_group = user.group
    new_group = Group.create!
    user.likes.delete_all
    user.rates.delete_all
    user.update!(group: new_group, status: 'normal', editing_name_id: nil, sound_rate_setting: nil, character_rate_setting: nil, fotune_telling_rate_setting: nil)
    leave_group.destroy if leave_group.users.empty?
    redirect_to new_user_path, success: 'ユーザー情報のリセットに成功しました'
  end
end
