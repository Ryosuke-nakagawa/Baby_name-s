class LikesController < ApplicationController

  def create
    first_name = FirstName.find(params[:first_name_id])
    current_user.like(first_name)
    redirect_to group_first_names_path(current_user.group), success: t('defaults.message.success')
  end

  def destroy
    first_name = current_user.likes.find(params[:id]).first_name
    current_user.unlike(first_name)
    redirect_to group_first_names_path(current_user.group), success: t('defaults.message.success')
  end
end
