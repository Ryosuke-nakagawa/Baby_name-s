class GroupsController < ApplicationController
  def new
    @user = User.find(session[:user_id])
    @group = @user.group
  end

  def update
    @user = User.find(session[:user_id])
    @group = Group.find(params[:id])
    binding.pry
    #hogehoge
    if @group.update(group_params) && @user.update(user_params)
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def group_params
    params.require(:group).permit(:last_name, users_attributes: [:id, :sound_rate_setting, :character_rate_setting, :fotune_telling_rate_setting])
  end
  def user_params
    params[:group].require(:user).permit(:sound_rate_setting, :character_rate_setting, :fotune_telling_rate_setting)
  end
end
