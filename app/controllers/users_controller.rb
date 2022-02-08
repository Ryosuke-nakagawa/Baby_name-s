class UsersController < ApplicationController
  before_action :set_login_liffid, only: %i[new]
  skip_before_action :login_required, only: %i[new create]

  require 'net/http'
  require 'uri'

  def new; end

  def create
    result = LineAuthenticateService.new(params[:idToken]).call
    user = User.find_by(line_id: result[:line_id])

    if params[:uuid] # 人からの紹介urlの場合
      link_user = User.find_by(uuid: params[:uuid])
      if user.nil?
        user = User.create!(line_id: result[:line_id], group: link_user.group, name: result[:name], avatar: result[:avatar])
      else
        user.update!(group: link_user.group, name: result[:name], avatar: result[:avatar])
      end
    end
    if user.nil?
      group = Group.create!
      user = User.create!(line_id: result[:line_id], group: group, name: result[:name], avatar: result[:avatar])
    else
      user.update!(name: result[:name], avatar: result[:avatar])
    end
    session[:user_id] = user.id
  end

  def destroy
    leave_group = current_user.group
    new_group = Group.create!
    user.likes.delete_all
    user.rates.delete_all
    user.update!(group: new_group, status: 'normal', editing_name_id: nil, sound_rate_setting: nil,
                 character_rate_setting: nil, fortune_telling_rate_setting: nil)
    leave_group.destroy if leave_group.users.empty?
    redirect_to new_user_path, success: 'ユーザー情報のリセットに成功しました'
  end
end
