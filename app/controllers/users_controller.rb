class UsersController < ApplicationController
  skip_before_action :login_required, only: %i[new create]

  def new; end

  def create
    lineauthenticate = LineAuthenticateService.new(params[:idToken])
    lineauthenticate.call
    user = lineauthenticate.search_user

    if params[:uuid] # 人からの紹介urlの場合
      link_user = User.find_by(uuid: params[:uuid])
      if user.nil?
        user = User.create!(user_params(lineauthenticate, link_user.group))
      else
        user.update!(user_params(result, link_user.group))
      end
    end
    if user.nil?
      group = Group.create!
      user = User.create!(user_params(result, group))
    else
      user.update!(name: lineauthenticate.name, avatar: lineauthenticate.avatar)
    end
    session[:user_id] = user.id
  end

  def destroy
    user = current_user
    leave_group = user.group
    new_group = Group.create!
    user.likes.delete_all
    user.rates.delete_all
    user.update!(group: new_group, status: 'normal', editing_name_id: nil, sound_rate_setting: nil,
                 character_rate_setting: nil, fortune_telling_rate_setting: nil)
    leave_group.destroy if leave_group.users.empty?
    redirect_to new_user_path, success: t('defaults.message.reset_user')
  end

  private

  def user_params(lineauthenticate, group)
    { group: group, line_id: lineauthenticate.line_id, name: lineauthenticate.name, avatar: lineauthenticate.avatar }
  end
end
